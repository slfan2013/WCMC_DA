# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input){
  library(pacman)
  pacman::p_load(data.table,parallel)
  # read.data
  data. = WCMC.Fansly::MetaboAnalystFormat(input,row_start = 2)
  e = as.matrix(data.$e)
  f = data.$f
  p = data.$p

  e = t(apply(e,1,function(x){
    x[is.na(x)] = 0.5*min(x,na.rm = T)
    return(x)
  }))


  multicore = T
  if(multicore){
    cl = makeCluster(min(detectCores(),20))
  }else{
    cl = makeCluster(1)
  }

  group=colnames(p)[2]
  tTest = parSapply(cl,1:nrow(e),function(j,e,p,group){
    t.test(e[j,]~p[[group]])$p.value
  },e,p,group)
  tTest.FDR=p.adjust(tTest,'fdr')

  medians = by(t(e),p[[length(p)]],function(x){
    sapply(x,median,na.rm=T)
  })
  FC = medians[[1]]/medians[[2]]


  result = data.table(f,tTest,tTest.FDR,FC)
  rownames(result) = 1:nrow(result)
  if(class(f)=="character"){
    colnames(result) = c(colnames_f_1,c('p value', 'adjusted p value',paste0("FC: ",names(medians)[1],"/",names(medians)[2])))
  }else{
    colnames(result) = c(colnames(f),c('p value', 'adjusted p value',paste0("FC: ",names(medians)[1],"/",names(medians)[2])))
  }

  fwrite(data.table(result),"tTest.csv")
  fwrite(data.table(result),"tTest.txt",sep = "\t")


  stopCluster(cl)

  return(result)


}
