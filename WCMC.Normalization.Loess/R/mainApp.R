# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,type,weight){
  library(pacman)
  pacman::p_load(data.table)
  input <- gsub("\r","",input)
  cfile <- strsplit(input,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
  colnames(df1) = as.matrix(df1[1,])[1,]
  df1 = df1[-1,]
  data = sapply(df1[,-1], as.numeric)

  if(type=="sum"){
    sums = colSums(data,na.rm = T)
    result = t(t(data)/sums*mean(sums,na.rm = T))
  }else if(type=="median"){
    medians = apply(data,2,median,na.rm = T)
    result = t(t(data)/medians*mean(medians,na.rm = T))
  }else if(type=='mean'){
    means = colMeans(data,na.rm = T)
    result = t(t(data)/means*mean(means,na.rm = T))
  }else if(type=="custom sample weight"){
    weight <- gsub("\r","",weight)
    cfile <- strsplit(weight,"\n")[[1]]
    df2 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
    colnames(df2) = as.matrix(df2[1,])[1,]
    df2 = df2[-1,]
    weight = as.numeric(df2[1,]);
    weight = weight[!is.na(weight)]
    result = t(t(data)*weight)
  }

  result = cbind(data.frame(df1[,1]),result)
  rownames(result) = 1:nrow(result)
  colnames(result) = colnames(df1)
  fwrite(data.table(result),"SampleSpecific-normalization.csv")
  fwrite(data.table(result),"SampleSpecific-normalization.txt",sep = "\t")
  return(result)
}
