# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input){
  library(pacman)
  pacman::p_load(data.table,affy)
  input <- gsub("\r","",input)
  cfile <- strsplit(input,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
  colnames(df1) = as.matrix(df1[1,])[1,]
  df1 = df1[-1,]
  data = sapply(df1[,-1], as.numeric)

  if(sum(is.na(data))>0){
    stop(paste0(sum(is.na(data))," missing value detected. Contrast normalization does not tolerate with missing values."))
  }


  #---First adaption: Make the data matrix non-negative
  threshold = 1e-11
  data[data <= 0] <- threshold
  #---Apply normalization
  maffy.data <- maffy.normalize(data, subset = 1:nrow(data), span = 0.75,
                                verbose = TRUE,
                                family = "gaussian", log.it = FALSE)
  #---Second adaption: Subtract 10% Quantile from each sample
  subtract <- function(x) {
    t(t(x) - apply(x, 2, quantile, 0.1,na.rm=T))
  }
  result <- subtract(maffy.data)


  result = cbind(data.frame(df1[,1]),result)
  rownames(result) = 1:nrow(result)
  colnames(result) = colnames(df1)
  fwrite(data.table(result),"Contrast-normalization.csv")
  fwrite(data.table(result),"Contrast-normalization.txt",sep = "\t")
  return(result)
}
