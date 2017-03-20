toSameScale = function(ori,norm){
  ori.min = apply(ori,1,min,na.rm=T)
  norm.min = apply(norm,1,min,na.rm=T)
  return(norm - c(norm.min - ori.min))
}
