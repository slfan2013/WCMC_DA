# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   center=T,
                   scale = T,
                   score_axis = c(1,2),
                   color = 'treatment',

                   num_of_var = 15,
                   contribute_axes=1
                   ){
  library(pacman)
  pacman::p_load(data.table,parallel, dendextend,
                 colorspace,gplots,stringr,RColorBrewer,mvtnorm,factoextra,FactoMineR)

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
  # eig.val <- get_eigenvalue(res.pca)



  png(filename = "ScreePlot.png",width=800,height=600)
  print(fviz_screeplot(res.pca, ncp=10,linecolor="red",addlabels=T))
  dev.off()

  png(filename = "Contributer.png",width=800,height=800)
  var = fviz_pca_var(res.pca, col.var="contrib")
  print(fviz_pca_var(res.pca, col.var="contrib") +
    scale_color_gradient2(low="white", mid="blue",
                          high="red", midpoint=median(var$data$contrib)) + theme_minimal())
  dev.off()

  contributes = get_pca_ind(res.pca)$contrib

  png(filename = "ContributerSingleDim.png",width=800,height=800)
  print(fviz_pca_contrib(res.pca, choice = "var", axes = as.numeric(contribute_axes), top = num_of_var))
  dev.off()

  png(filename = "ScorePlot.png",width=800,height=800)
  if(length(unique(p[[color]]))<2){
    print(fviz_pca_ind(res.pca,addEllipses = TRUE, ellipse.level = 0.95,repel=T,axes = as.numeric(score_axis),
                       res = 300) +
            theme_minimal())
  }else{
    print(fviz_pca_ind(res.pca,
                       habillage = p[[color]], addEllipses = TRUE, ellipse.level = 0.95,repel=T,axes = as.numeric(score_axis),
                       res = 300) +
            theme_minimal())
  }
  dev.off()

  scores = res.pca$x
  loadings = res.pca$rotation
  fwrite(data.table(scores),"Scores.csv")
  fwrite(data.table(loadings),"Loadings.csv")



  res.pca <- PCA(t(e), graph = FALSE)
  fwrite(data.table(res.pca$var$coord),"CompoundContribution.csv")

  zip(zipfile = "PCA.zip",files = c("Scores.csv",
                                                   "Loadings.csv",
                                                   "ScreePlot.png",
                                                   "Contributer.png",
                                                   "ContributerSingleDim.png",
                                                   "ScorePlot.png",
                                                   "CompoundContribution.csv"))
}
