# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,posthocNeeded = T){
  library(pacman)
  pacman::p_load(data.table,parallel)
  # read.data
  data. = WCMC.Fansly::MetaboAnalystFormat(input,row_start = 2)
  e = as.matrix(data.$e)
  f = data.$f
  p = data.$p

  multicore = T
  if(multicore){
    cl = makeCluster(min(detectCores(),2))
  }else{
    cl = makeCluster(1)
  }

  group=colnames(p)[2]
  OneWayANOVA = parSapply(cl,1:nrow(e),function(j,e,p,group){
    oneway.test(e[j,]~p[[group]])$p.value
  },e,p,group)

  result = data.table(f,OneWayANOVA)
  if(posthocNeeded){
    pacman::p_load(userfriendlyscience)
    posthoc = parSapply(cl,1:nrow(e),function(j,e,p,group,posthocTGH){
      posthocTGH(e[j,] ,p[[group]], digits=4)$output[["games.howell"]][,'p']
    },e,p,group,posthocTGH)
    posthoc = data.table(t(posthoc))

    colnames(posthoc) = rownames(posthocTGH(e[1,] ,p[[group]], digits=4)$output[["games.howell"]])

    result = data.table(result,posthoc)
  }



  rownames(result) = 1:nrow(result)

  fwrite(data.table(result),"OneWayANOVA.csv")
  fwrite(data.table(result),"OneWayANOVA.txt",sep = "\t")


  stopCluster(cl)

  return(result)


}
