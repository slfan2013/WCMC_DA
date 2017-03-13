# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,method="median"){
  library(pacman)
  pacman::p_load(data.table,parallel,MKmisc)
  # read.data
  {
    data.list = WCMC.Fansly::MetaboAnalystFormat(input=input, row_start = 2)
    p = data.list$p
    f = data.list$f
    e = data.list$e
  }

  e = as.matrix(e)
  # e = t(apply(e,1,function(x){
  #   x[is.na(x)] = 0.5*min(x,na.rm = T)+rnorm(sum(is.na(x)),mean=0,sd = 0.1)
  #   return(x)
  # }))
  # if(twoway){

  # }else{
    means = by(t(e),p[[length(p)]],function(x){
              sapply(x,eval(parse(text=method)),na.rm=T)
            })
    indexes = combn(1:length(means), 2)
    FC = list()
    for(i in 1:ncol(indexes)){
      FC[[i]] = means[[indexes[1,i]]]/means[[indexes[2,i]]]
      names(FC)[i] = paste0("FC: ",names(means)[indexes[1,i]],"/",names(means)[indexes[2,i]])
    }
    result = do.call(cbind,FC)
  # }



  # multicore = Sys.info()['sysname']=="Windows"
  # if(multicore){
  #   cl = makeCluster(min(detectCores(),2))
  # }else{
  #   cl = makeCluster(1)
  # }

  # if(!twoway){
  #   FC. = parSapply(cl = cl, 1:nrow(e),FUN = function(j,e,pairwise.fc,p){
  #     pairwise.fc(as.numeric(e[j,]), p[[2]], ave = mean, log = FALSE,mod.fc = FALSE)
  #   },e,pairwise.fc,p)
  #
  #   if(class(FC.)=='numeric'){
  #     FC = data.frame(FC.)
  #     colnames(FC) = names(FC.)[1]
  #
  #   }else{
  #     FC. = t(FC.)
  #     FC = data.frame(FC.,check.names = F)
  #   }
  #
  #   result = FC
  #   result = data.frame(f,result,check.names = F)
  # }else{
  #
  # }


  # stopCluster(cl)

  fwrite(data.table(result),"FoldChanges.csv")
  fwrite(data.table(result),"FoldChanges.txt",sep = "\t")

  return(FC)
}
