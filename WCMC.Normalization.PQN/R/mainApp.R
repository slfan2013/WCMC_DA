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
  data = sapply(df1[,-1], as.numeric)

  reference <- apply(data, 1, median)
  quotient <- data / reference
  quotient.median <- apply(quotient, 2, median)
  result <- t(t(data) / quotient.median)


  result = cbind(data.frame(df1[,1]),result)
  rownames(result) = 1:nrow(result)
  colnames(result) = colnames(df1)
  fwrite(data.table(result),"PQN-normalization.csv")
  fwrite(data.table(result),"PQN-normalization.txt",sep = "\t")
  return(result)
}
