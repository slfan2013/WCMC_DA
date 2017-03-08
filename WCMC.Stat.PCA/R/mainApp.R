# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   center=T,
                   scale = T,
                   ){
  library(pacman)
  pacman::p_load(data.table,parallel, dendextend,
                 colorspace,gplots,stringr,RColorBrewer,mvtnorm,factoextra)

  data. = WCMC.Fansly::FiehnLabFormat(input)
  e = data.$e
  f = data.$f
  p = data.$p

  # e = fread("e.csv")[,-1]
  # f = fread("f.csv")[,-1]
  # p = fread("p.csv")[,-1]

  e = as.matrix(e)
  # rownames(e) = f[[length(f)]]


  # e = t(apply(e,1,function(x){
  #   x[is.na(x)] = 0.5*min(x,na.rm = T)
  #   return(x)
  # }))

  #pca
  res.pca <- prcomp(t(e),center = center, scale = scale)
  eig.val <- get_eigenvalue(res.pca)

  fviz_screeplot(res.pca, ncp=10,linecolor="red",addlabels=T)

  fviz_pca_var(res.pca)



}
