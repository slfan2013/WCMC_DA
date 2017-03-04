# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input){
  library(pacman)
  pacman::p_load(data.table,parallel,MKmisc)
  # read.data
  {
    data.list = WCMC.Fansly::MetaboAnalystFormat(input=input, row_start = 2)
    p = data.list$p
    f = data.list$f
    e = data.list$e
  }

  # e = fread("e.csv")[,-1]
  # f = fread("f.csv")[,-1]
  # p = fread("p.csv")[,-1]





  e = as.matrix(e)
  e = t(apply(e,1,function(x){
    x[is.na(x)] = 0.5*min(x,na.rm = T)+rnorm(sum(is.na(x)),mean=0,sd = 0.1)
    return(x)
  }))

  multicore = T
  if(multicore){
    cl = makeCluster(min(detectCores(),20))
  }else{
    cl = makeCluster(1)
  }

  FC. = parSapply(cl = cl, 1:nrow(e),FUN = function(j,e,pairwise.fc,p){
    pairwise.fc(as.numeric(e[j,]), p[[2]], ave = mean, log = FALSE,mod.fc = FALSE)
  },e,pairwise.fc,p)

  if(class(FC.)=='numeric'){
    FC = data.frame(FC.)
    colnames(FC) = names(FC.)[1]

  }else{
    FC. = t(FC.)
    FC = data.frame(FC.,check.names = F)
  }

  result = FC
  result = data.frame(f,result,check.names = F)

  stopCluster(cl)

  fwrite(data.table(result),"FoldChanges.csv")
  fwrite(data.table(result),"FoldChanges.txt",sep = "\t")

  return(FC)
}
