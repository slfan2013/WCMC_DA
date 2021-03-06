# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   normalizationMethodsSelection=c("None","mTIC","SampleSpecific","Quantile","PQN","contrast",'batch','loess'),
                   autoSpan = F,
                   sampleSpecificMethodsSelection=c('sum','median','mean'),
                   sampleSpecificWeight,
                   transformationMethodsSelection=c("None","log","power"),
                   logbase="exp(1)",
                   power=1/3,
                   scaleMethodsSelection=c("None","centering","auto",'parato','vast','level','range'),
                   PCA=TRUE,
                   Normality=TRUE,
                   RSD=TRUE){
  library(pacman)
  pacman::p_load(data.table,affy,WCMC.Fansly, dendextend,colorspace,gplots,stringr,RColorBrewer,mvtnorm,factoextra,FactoMineR,xlsx)
  input <- gsub("\r","",input)

  data = WCMC.Fansly::FiehnLabFormat(input)
  e = data$e
  f = data$f
  p = data$p

  # e = fread("e.csv")
  # f = fread("f.csv")
  # p = fread("p.csv")


  start = Sys.time()

  e = as.matrix(e)

  e = t(apply(e,1,function(x){
    x[is.na(x)] = 0.5*min(x,na.rm = T)
    return(x)
  }))

  normalizationList = list()
  for(normalization in normalizationMethodsSelection){
    if(normalization=='None'){
      e1 = e
      normalizationList[[normalization]] = e1
    }
    if(normalization=='mTIC'){
      sums = apply(e[f[["Known/Unknown"]]=='Known',],2,  sum, na.rm=T)
      mean_sums = mean(sums)
      e1 = t(t(e)/(sums/mean_sums))
      e1 = toSameScale(e,e1)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
    if(normalization=="SampleSpecific"){
      if("sum"%in%sampleSpecificMethodsSelection){
        sums = colSums(e,na.rm = T)
        e1 = t(t(e)/sums*mean(sums,na.rm = T))
        e1 = toSameScale(e,e1)
        rownames(e1) = rownames(e)
        colnames(e1) = colnames(e)
        normalizationList[["SampleSpecific~sum"]] = e1
      }
      if("median"%in%sampleSpecificMethodsSelection){
        medians = apply(e,2,median,na.rm = T)
        e1 = t(t(e)/medians*mean(medians,na.rm = T))
        e1 = toSameScale(e,e1)
        rownames(e1) = rownames(e)
        colnames(e1) = colnames(e)
        normalizationList[["SampleSpecific~median"]] = e1
      }
      if("mean"%in%sampleSpecificMethodsSelection){
        means = colMeans(e,na.rm = T)
        e1 = t(t(e)/means*mean(means,na.rm = T))
        e1 = toSameScale(e,e1)
        rownames(e1) = rownames(e)
        colnames(e1) = colnames(e)
        normalizationList[["SampleSpecific~mean"]] = e1
      }
      if("custom sample weight"%in%sampleSpecificMethodsSelection){
        # weight <- gsub("\r","",sampleSpecificWeight)
        # cfile <- strsplit(weight,"\n")[[1]]
        # df2 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
        # colnames(df2) = as.matrix(df2[1,])[1,]
        # df2 = df2[-1,]
        # colnames(df2)[2:ncol(df2)] = colnames(df2)[1:(ncol(df2)-1)]
        # colnames(df2)[1] = 'column1'
        # df2 = df2[,c('column1',colnames(df1)[2:ncol(df1)])]
        # weight = as.numeric(df2[1,]);
        # weight = weight[!is.na(weight)]
        # e1 = t(t(e)*weight)
        # e1 = toSameScale(e,e1)
        # rownames(e1) = rownames(e)
        # colnames(e1) = colnames(e)
        # normalizationList[["SampleSpecific_customweight"]] = e1
      }
    }
    if(normalization=="Quantile"){
      normalize.quantile <- get("normalize.quantiles", en = asNamespace("affy"))
      e1 <- normalize.quantile(e)
      e1 = toSameScale(e,e1)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
    if(normalization=="PQN"){
      reference <- apply(e, 1, median,na.rm = T)
      quotient <- e / reference
      quotient.median <- apply(quotient, 2, median,na.rm = T)
      e1 <- t(t(e) / quotient.median)
      e1 = toSameScale(e,e1)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
    if(normalization=="contrast"){
      #---First adaption: Make the e matrix non-negative
      threshold = 1e-11
      e[e <= 0] <- threshold
      #---Apply normalization

      maffy.e <- tryCatch(maffy.normalize(e, subset = 1:nrow(e), span = 0.75,
                                    verbose = TRUE,
                                    family = "gaussian", log.it = FALSE),error=function(er){
                                      NA
                                    })
      #---Second adaption: Subtract 10% Quantile from each sample
      subtract <- function(x) {
        t(t(x) - apply(x, 2, quantile, 0.1,na.rm=T))
      }
      if(!is.na(maffy.e)){
        e1 <- tryCatch(subtract(maffy.e),error=function(er){NA})
        if(!is.na(e1)){
          e1 = toSameScale(e,e1)
          rownames(e1) = rownames(e)
          colnames(e1) = colnames(e)
          normalizationList[[normalization]] = e1
        }
      }

    }
    if(normalization == 'batch'){
      p$QC = as.logical(p$QC)
      e_batch_norm = matrix(,nrow=nrow(e),ncol=ncol(e))
      for(i in 1:nrow(f)){
        means = by(as.numeric(e[i,p$QC]),p$batch[p$QC], mean, na.rm=T)
        mean_means = mean(means)
        e_batch_norm[i,] = as.numeric(e[i,])-(rep(means,times=table(p$batch))-mean_means)
      }
      e1 = toSameScale(e,e_batch_norm)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
    if(normalization == "loess"){
      p$QC = as.logical(p$QC)
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

      # if(.Platform$OS.type == "windows"){
        cl = makeCluster(min(8,detectCores()))
      # }else{
        # cl = makeCluster(1)
      # }

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
      stopCluster(cl)

      e1 =toSameScale(e, e_norm)

      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
  }

  transformationList = list()
  for(i in 1:length(normalizationList)){
    e1 = normalizationList[[i]]
    if("None"%in%transformationMethodsSelection){
      e2 = e1
      rownames(e2) = rownames(e)
      colnames(e2) = colnames(e)
      transformationList[[paste0(names(normalizationList)[i],"_None")]] = e2
    }
    if("log"%in%transformationMethodsSelection){
      e2 = log(e1+1,base = eval(parse(text=logbase)))
      rownames(e2) = rownames(e)
      colnames(e2) = colnames(e)
      transformationList[[paste0(names(normalizationList)[i],"_log")]] = e2
    }
    if("power"%in%transformationMethodsSelection){
      e2 = (e1+1)^eval(parse(text=power))
      rownames(e2) = rownames(e)
      colnames(e2) = colnames(e)
      transformationList[[paste0(names(normalizationList)[i],"_power")]] = e2
    }
  }

  scaleList = list()
  for(i in 1:length(transformationList)){
    e2 = transformationList[[i]]
    if("None"%in%scaleMethodsSelection){
      e3 = e2
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_None")]] = e3
    }
    if("centering"%in%scaleMethodsSelection){
      e3 = t(scale(t(e2),scale = F))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_centering")]] = e3
    }
    if("auto"%in%scaleMethodsSelection){
      e3 = t(scale(t(e2)))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_auto")]] = e3
    }
    if("parato"%in%scaleMethodsSelection){
      e3 = t(scale(t(e2),scale = apply(t(e2),2,function(x){sqrt(sd(x,na.rm = T))})))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_parato")]] = e3
    }
    if("vast"%in%scaleMethodsSelection){
      e3. = t(scale(t(e2),scale = T))
      e3 = e3. * (apply(e2,1,function(x){mean(x,na.rm = T)/sd(x,na.rm = T)}))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_vast")]] = e3
    }
    if("level"%in%scaleMethodsSelection){
      mean. = rowMeans(e2,na.rm=T)
      e3 = (e2 - mean.)/mean.
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_level")]] = e3
    }
    if("range"%in%scaleMethodsSelection){
      e3 = t(apply(e2,1,function(x){
        (x - mean(x))/diff(range(x))
      }))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_range")]] = e3
    }
  }

  dir.create("data")
  # if(.Platform$OS.type == "windows"){
    cl = makeCluster(min(8,detectCores()))
    parSapply(cl,1:length(scaleList),FUN=function(i,scaleList,fwrite,data.table){
      fwrite(data.table(scaleList[[i]]),file=paste0("data/",names(scaleList)[i],".csv"))
      return(NULL)
    },scaleList,fwrite,data.table)
    stopCluster(cl)
  # }else{
  #   for(i in 1:length(scaleList)){
  #     fwrite(data.table(scaleList[[i]]),file=paste0("data/",names(scaleList)[i],".csv"))
  #   }
  # }

  if(PCA){
    dir.create("PCA")
    # dir.create("PCA/scores")
    dir.create("PCA/plots")
    PCAs = list()
    del = sapply(names(scaleList),function(x){
      substring(x,nchar(x)-4)
    })=="_None"
    scaleList. = scaleList[!del]
    for(i in 1:length(scaleList.)){
      scaleList.[[i]] = t(apply(scaleList.[[i]],1,function(x){
        x[is.na(x)]=median(x,na.rm = T)
        x
      }))
      scaleList.[[i]] = scaleList.[[i]][!is.na(scaleList.[[i]][,1]),]
      res.pca <- prcomp(t(scaleList.[[i]]),center = F, scale. = F)
      if(length(unique(p[["PCA_color"]]))<2){
        PCAs[[i]]=fviz_pca_ind(res.pca,addEllipses = F, ellipse.level = 0.95,repel=T,axes = c(1,2),
                           res = 150,geom="point",title=names(scaleList.)[i]) +
                theme_minimal()
      }else{
        PCAs[[i]]=fviz_pca_ind(res.pca,
                           habillage = p[["PCA_color"]], addEllipses = F, ellipse.level = 0.95,repel=T,axes = c(1,2),
                           res = 150,geom="point",title=names(scaleList.)[i],axes.linetype = "dotted") +
                theme_minimal()
      }
      # fwrite(cbind(data.table(compounds = f$`compound label`),data.table(res.pca$x)),paste0("PCA/scores/",names(scaleList.)[i],"_PCAscore.csv"))
    }


    for(i in 1:length(PCAs)){
      png(filename = paste0("PCA/plots/",names(scaleList.)[i],".png"),width=400,height=400)
      print(PCAs[[i]])
      dev.off()
    }

  }

  if(Normality){
    dir.create("Normality")
    Normalitys = list()
    del = duplicated(sapply((strsplit(names(scaleList),"_")),function(x){
      paste0(x[1],"_",x[2])
    }))
    scaleList. = scaleList[!del]
    names(scaleList.) = substring(names(scaleList.),first=1,last = nchar(names(scaleList.))-5)
    for(i in 1:length(scaleList.)){
      Normalitys[[i]]=apply(scaleList.[[i]],1,function(x){
        shapiro.test(lm(x~p$Normality_factor)$res)$p.value
      })
    }

    plevel = sapply(Normalitys, function(x){
      as.character(cut(x,c(-1,0.05,1),labels=c("Reject Normality","Failt to reject Normality")))
    })
    plevel = factor(plevel,levels = c("Reject Normality","Failt to reject Normality"))
    Normalizatio.methods = rep(names(scaleList.),each=nrow(e))
    Normalizatio.methods = factor(Normalizatio.methods,levels=names(scaleList.))
    stackHist = data.frame("Normalization methods" = Normalizatio.methods,
                           "test level" = plevel)
    ggplot(stackHist,aes(x = Normalizatio.methods))+
      geom_bar(aes(fill=test.level),color="black")+
      theme_minimal()+ theme(axis.text.x = element_text(angle = 90, hjust = 1))
    ggsave("Normality/NormalityTest.png",height=8,width = max(length(Normalitys)/2,5))

    fwrite(data.table(do.call("cbind",Normalitys)),"Normality/Normality.csv")
  }

  if(RSD){
    p$RSD = as.logical(p$RSD)
    dir.create("RSD")
    RSDs = list()
    scaleList. = scaleList[grepl("_None_None",names(scaleList))]
    names(scaleList.) = gsub("_None_None","",names(scaleList.))
    for(i in 1:length(scaleList.)){
      RSDs[[i]]=apply(scaleList.[[i]],1,function(x){
        x. = x[p$RSD]
        sd(x.,na.rm = T)/mean(x.,na.rm = T)
      })
    }

    RSD.table = data.table(do.call("cbind",RSDs))
    RSD.table = cbind(data.table(f$`compound label`),RSD.table)
    colnames(RSD.table) = c("compound label",names(scaleList.))
    fwrite(RSD.table,"RSD/RSD.csv")

    RSD. = sapply(RSDs,median,na.rm=T)
    names(RSD.) = names(scaleList.)
    RSD. = sort(RSD.,decreasing = T)
    bar.ggplot2 = data.frame(RSD = signif(RSD.,3),methods = factor(names(RSD.),levels = names(RSD.)))

    ggplot(bar.ggplot2, aes(x = methods, y = RSD.)) + geom_bar(stat = "identity",fill = c(rep("black",length(RSD.)-1),"red"))+
      theme(text = element_text(size=10),axis.text.x = element_text(angle=90, hjust=1))+
      geom_text(aes(label=RSD), vjust=-.5, colour="black")+ggtitle("Median of QC RSD")+theme(
        plot.title = element_text(size = rel(1.2), hjust = 0.5,face = 'bold',family = "Arial"),#title size.
        axis.text	 = element_text(colour = 'black'),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.key = element_rect(fill = "white",colour = "white"),
        legend.title = element_text(face = 'bold'),
        text=element_text(family="Arial")
      )
    ggsave("RSD/QC performance plot2.png",width = 6, height = 6)
  }




  files = list.files(all.files = F,recursive = T)
  files = files[!files%in%c("e.csv","f.csv","p.csv")]
  zip("Normalization_Results.zip",files = files)
  end = Sys.time()



}





















