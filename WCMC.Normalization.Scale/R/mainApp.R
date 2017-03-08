# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input, method = 'auto'){
  library(pacman)
  pacman::p_load(data.table)
  input <- gsub("\r","",input)
  cfile <- strsplit(input,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
  colnames(df1) = as.matrix(df1[1,])[1,]
  df1 = df1[-1,]
  data = sapply(df1[,-1], as.numeric)


  if(method=="auto"){
    result = t(scale(t(data)))
  }else if(method == 'centering'){
    result = t(scale(t(data),scale = F))
  }else if(method=="range"){
    result = t(apply(data,1,function(x){
      (x - mean(x))/diff(range(x))
    }))
  }else if(method=="pareto"){
    result = t(scale(t(data),scale = apply(t(data),2,function(x){sqrt(sd(x,na.rm = T))})))
  }else if(method=="vast"){
    result. = t(scale(t(data),scale = T))
    result = result. * (apply(data,1,function(x){mean(x,na.rm = T)/sd(x,na.rm = T)}))
  }else if(method=="level"){
    mean. = rowMeans(data,na.rm=T)
    result = (data - mean.)/mean.
  }


  result = cbind(data.frame(df1[,1]),result)
  rownames(result) = 1:nrow(result)
  colnames(result) = colnames(df1)
  fwrite(data.table(result),"Scale-normalization.csv")
  fwrite(data.table(result),"Scale-normalization.txt",sep = "\t")
  return(result)
}
