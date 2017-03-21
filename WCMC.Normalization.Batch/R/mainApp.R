# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,type){
  library(pacman)
  pacman::p_load(data.table)
  input <- gsub("\r","",input)
  cfile <- strsplit(input,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)

  p = df1[1:3,]
  p = t(p)
  colnames(p) = p[1,]
  p = p[-1,]
  p = data.frame(p,stringsAsFactors = F)
  p$QC = as.logical(p$QC)


  f=data.frame(df1[4:nrow(df1),1])
  colnames(f) = 'compound label'

  e = df1[4:nrow(df1),2:ncol(df1)]
  e = as.matrix(e)


  e_batch_norm = matrix(,nrow=nrow(e),ncol=ncol(e))
  for(i in 1:nrow(f)){
    means = by(as.numeric(e[i,p$QC]),p$batch[p$QC], mean, na.rm=T)
    mean_means = mean(means)
    e_batch_norm[i,] = as.numeric(e[i,])-(rep(means,times=table(p$batch))-mean_means)
  }
  rownames(e_batch_norm) = rownames(e)
  colnames(e_batch_norm) = colnames(e)
  e_batch_norm = WCMC:Fansly(toSameScale(e,e_batch_norm))
  colnames(e_batch_norm) = p$label
  e_batch_norm = cbind(data.table(compounds=f$`compound label`),e_batch_norm)

  fwrite(data.table((e_batch_norm)),"batch_normalization.csv")
  fwrite(data.table(e_batch_norm),"batch_normalization.txt")
}
