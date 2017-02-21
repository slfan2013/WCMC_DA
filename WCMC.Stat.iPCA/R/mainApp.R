# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   center,
                   scale){
  library(pacman)
  pacman::p_load(data.table,jsonlite,plotrix)
  input = gsub("\r","",input)
  # For some reason, the '\t' at the beginning of the first row is missing. Have to replace them back.
  # Check how many '\t' each row has. Then add the missing '\t's to the first element of cfile.
  cfile = strsplit(input,"\n")[[1]]

  ts = sapply(regmatches(cfile, gregexpr("\t", cfile)),length)
  t.mode = unique(ts)[which.max(tabulate(match(ts, unique(ts))))]
  ts.first.row = ts[1]
  cfile[[1]] = paste0(paste0(rep('\t',t.mode-ts.first.row),collapse = ''),cfile[[1]],collapse = '')


  df1 = as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)

  col_start = t.mode-ts.first.row + 1
  row_start = which(diff(df1[,1]=='')==-1) + 1
  if(length(row_start)==0 & col_start ==1){
    row_start = 1
  }else if(length(row_start)==0){
    stop("There is an error in the input format. Please click the '!' icon (next to 'Example Data File') for more information.")
  }

  p = t(df1[1:(row_start-1),col_start:ncol(df1)])
  colnames(p) = p[1,]
  p = cbind(data.frame("sample index" = c(1,as.character(df1[row_start,(col_start+1):ncol(df1)])),check.names = FALSE),
            p)[-1,]

  rownames(p) = df1[row_start,(col_start+1):ncol(df1)]
  p = data.frame(p,stringsAsFactors = F,check.names = F)
  # write.csv(p,"p.csv")

  f = df1[row_start:nrow(df1),1:col_start]

  if(class(f) == "character"){ #in case there is only one column of feature index.
    name.temp = f[1]
    f = data.frame(f[-1])
    colnames(f) = name.temp
  }else{
    colnames(f) = f[1,]
    f = f[-1,]
  }
  rownames(f) = 1:nrow(f)

  # write.csv(f,"f.csv")

  e = df1[(row_start+1):nrow(df1),(col_start+1):ncol(df1)]
  e = apply(e,2,as.numeric)
  colnames(e) = rownames(p)
  rownames(e) = rownames(f)
  # write.csv(e,"e.csv")

  p_names = colnames(p)
  f_names = colnames(f)

  e_scale = t(scale(t(e),center=center,scale=scale))

  if(nrow(e_scale)>ncol(e_scale)){
    sampleLessThanFeature = T
    ori_nrow = nrow(e)
    ori_ncol = ncol(e)
    e_scale = cbind(e_scale,matrix(0,nrow=nrow(e_scale),ncol = nrow(e_scale)-ncol(e_scale)))
  }else{
    sampleLessThanFeature = F
    ori_nrow  = ori_ncol = NA
  }



  # server work.
  # for parallel coordinate.
  {
    e_Top = paste0(
      f[,1],'<br/><span style="font-weight:normal;">',round(apply(e,1,max,na.rm=T),2),'</span>'
    )
    e_Bot = paste0(
      f[,1],'<br/><span style="font-weight:normal;">',round(apply(e,1,min,na.rm=T),2),'</span>'
    )

    temp = data.frame(apply(t(e),2,rescale,newrange=c(0,100)),stringsAsFactors = F)
    colnames(temp) = f[,1]
    dataframe_e = list()
    for(i in 1:ncol(e)){
      dataframe_e[[i]] = list(
        name = p[i,1],
        data = as.numeric(temp[i,])
      )
    }
  }


  result = list(
    # variance=variance,
                # scores = scores,
                # loadings = loadings,
                # init_pcaPlotData = init_pcaPlotData,
                p_names = p_names,
                f_names = f_names,
                e = e_scale,
                f = f,
                p = p,
                e_Top = e_Top,
                e_Bot =e_Bot,
                dataframe_e = toJSON(dataframe_e,auto_unbox = T),
                sampleLessThanFeature = sampleLessThanFeature,
                ori_nrow= ori_nrow,
                ori_ncol= ori_ncol
                )




  return(result)
}
