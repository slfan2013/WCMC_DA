# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,autoSpan=T){
  library(pacman)
  pacman::p_load(data.table,parallel)
  input <- gsub("\r","",input)
  cfile <- strsplit(input,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)

  p = df1[1:4,]
  p = t(p)
  colnames(p) = p[1,]
  p = p[-1,]
  p = data.frame(p,stringsAsFactors = F)
  p$QC = as.logical(p$QC)


  f=data.frame(df1[5:nrow(df1),1])
  colnames(f) = 'compound label'

  e = df1[5:nrow(df1),2:ncol(df1)]
  e = as.matrix(e)
  e = apply(e,2,as.numeric)


  get_loess_para = function(x,y,loess.span.limit = 0.5){ # use leave-one-out to select the best span parameter.
    j = 0
    error = rep(0, length(c(seq(loess.span.limit,1.5,0.1),1.75,2,2.25,2.5)))
    for(par in c(seq(loess.span.limit,1.25,0.1),1.5,2)){
      j = j+1
      for(i in 2:(length(y)-1)){ # if i from 1 or to length(y), the prediction would be NA
        o = loess(y[-i]~x[-i],span = par)
        if(sum(is.na(o))){
          error[j] = Inf
        }else{
          err = abs(predict(o,newdata = x[i]) - y[i])
          error[j] = sum(error[j],err,na.rm = T)
        }
      }
    }
    return(c(seq(loess.span.limit,1.5,0.1),1.75,2,2.25,2.5)[which.min(error)])
  }
  remove_outlier = function(v){ # sometimes, the outlier of QC would be disaster when fitting loess. So we have to remove them.
    out = boxplot(v,plot=F)$out
    return(list(value = v[!v%in%out],index = which(v%in%out)))
  }
  p$injectionOrder = as.numeric(p$injectionOrder)
  QC.index = p$QC
  batch = matrix(p$batch,nrow = nrow(e),ncol = ncol(e),byrow = T)
  divide = T


  time = "injectionOrder"
  if(autoSpan){
    span.para = "auto"
    loess.span.limit = 0.5
  }else{
    span.para = 0.75
    loess.span.limit = 0.5
  }

  if(.Platform$OS.type == "windows"){
    cl = makeCluster(min(20,detectCores()))
  }else{
    cl = makeCluster(1)
  }

  norms = parSapply(cl, X = 1:nrow(e), function(i,e,f,p,QC.index,batch,time,remove_outlier,span.para,get_loess_para,
                                                loess.span.limit){
    models = by(data.frame(v=e[i,QC.index],t=p[[time]][QC.index]),
                batch[i,QC.index],function(x){
                  # x = data.frame(v=e[i,QC.index],t=p[[time]][QC.index])[batch[i,QC.index]=="B",]
                  if(length(remove_outlier(x$v)[[2]])>0){# if outlier exists.
                    span = ifelse(span.para=='auto',
                                  get_loess_para(x=x$t[-remove_outlier(x$v)[[2]]],y=remove_outlier(x$v)[[1]],
                                                 loess.span.limit = loess.span.limit),span.para) # find a proper span.
                  }else{
                    span = ifelse(span.para=='auto',
                                  get_loess_para(x=x$t,y=x$v,
                                                 loess.span.limit = loess.span.limit),span.para) # find a proper span.

                  }
                  if(length(remove_outlier(x$v)[[2]])>0){
                    loess(v~t,data=x[-remove_outlier(x$v)[[2]],],span=span)
                  }else{
                    loess(v~t,data=x,span=span)
                  }
                })
    # predict using the models.
    norm = mapply(function(u,v){
      o = tryCatch({
        predict(u,newdata = v)
      },
      error = function(e){
        print(e)
        v
      })
    },models,by(p[[time]],batch[i,],function(x){x}))
    norm = unlist(norm)
    # replace NA with the closest value.
    if(length(which(is.na(norm)))>0){
      for(j in which(is.na(norm))){
        time_notNA = p[[time]][-which(is.na(norm))]
        closest_time = time_notNA[which.min(abs(time_notNA - p[[time]][j]))]
        norm[j] = norm[which(p[[time]]==closest_time)]
      }
    }
    return(norm)
  },e,f,p,QC.index,batch,time,remove_outlier,span.para,get_loess_para,loess.span.limit)

  norms = t(norms)
  e_norm = matrix(NA,nrow=nrow(f),ncol=nrow(p))
  if(divide){
    for(i in 1:nrow(f)){
      e_norm[i,] = e[i,] / (norms[i,] / median(e[i,]))
    }
  }else{
    for(i in 1:nrow(f)){
      e_norm[i,] = e[i,] - (norms[i,] - median(e[i,]))
    }
  }

  rownames(e_norm) = rownames(e)
  colnames(e_norm) = colnames(e)
  stopCluster(cl)

  e_norm = WCMC.Fansly::toSameScale(e,e_norm)
  colnames(e_norm) = p$label
  e_norm = cbind(data.table(compounds=f$`compound label`),e_norm)

  fwrite(data.table(e_norm),"loess_normalization.txt")
  fwrite(data.table(e_norm),"loess_normalization.csv")

}
