# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input){
  library(pacman)
  pacman::p_load(data.table)
  input <- gsub("\r","",input)
  cfile <- strsplit(input,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
  colnames(df1) = as.matrix(df1[1,])[1,]
  df1 = df1[-1,]
  data = sapply(df1[,-c(1,2)], as.numeric)
  sums = apply(data[df1[,2]=='known',],2,  sum, na.rm=T)
  mean_sums = mean(sums)
  result = t(t(data)/(sums/mean_sums))
  result = cbind(data.frame(compound = df1[,1]),result)
  rownames(result) = 1:nrow(result)
  fwrite(result,"mTIC-normalization.csv")
  fwrite(data.table(result),"mTIC-normalization.txt",sep = "\t")
  return(result)
}
