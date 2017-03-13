# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input){
  library(pacman)
  pacman::p_load(data.table,parallel)
  # read.data
  data. = WCMC.Fansly::MetaboAnalystFormat(input,row_start = 3)
  e = data.$e
  f = data.$f
  p = data.$p


  e = as.matrix(e)

  e = e[,order(p[[3]])]
  p = p[order(p[[3]]),]

  multicore = Sys.info()['sysname']=="Windows"
  if(multicore){
    cl = makeCluster(min(detectCores(),2))
  }else{
    cl = makeCluster(1)
  }


  group=colnames(p)[2]
  PairedTtest = parSapply(cl,1:nrow(e),function(j,e,p,group){
    t.test(e[j,]~p[[group]])$p.value
  },e,p,group)
  PairedTtest.FDR=p.adjust(PairedTtest,'fdr')

  result = data.table(f,PairedTtest,PairedTtest.FDR)
  rownames(result) = 1:nrow(result)
  if(class(f)=="character"){
    colnames(result) = c(colnames_f_1,c('p value', 'adjusted p value'))
  }else{
    colnames(result) = c(colnames(f),c('p value', 'adjusted p value'))
  }

  fwrite(data.table(result),"PairedTtest.csv")
  fwrite(data.table(result),"PairedTtest.txt",sep = "\t")


  stopCluster(cl)

  return(result)


}
