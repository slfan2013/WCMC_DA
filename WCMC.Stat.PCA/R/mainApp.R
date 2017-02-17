### Idea is to make One package for each statistical analysis. The moment we have multiple packages installed, R would crash and nothing would work easiy. For example, we would have one package for PCA as this one and then one for PLS-DA and then so son. One for each statistical tests and then one for survival model and the list keeps going on. People can run simulation to check how this work.
## ChemRICH : Set Enrichment Analysis using Chemical Similarity Networks.
## Authors : Dinesh Kumar Barupal (dinkumar@ucdavis.edu) & Oliver Fiehn (ofiehn@ucdavis.edu)
## For details visit - https://github.com/barupal
## Download and start Cytoscape 3.4.0 version.
## stat_file <- readChar("./data/stat_test.txt", nchars = 100000000)
createPCA <- function(stat_file) {
  library(pacman)
  pacman::p_load(mixOmics,RJSONIO,RCurl,stringr, ggplot2, httr,grid, png,ReporteRs,svglite, ChemRICH)
  stat_file <- gsub("\r","",stat_file)
  cfile <- strsplit(stat_file,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind, lapply(cfile, function (x) { strsplit(x,"\t")[[1]]  } )))
  df2 <- df1[3:nrow(df1),2:ncol(df1)]
  df2 <- df2[which(sapply(1:nrow(df2), function(x) { length(which(df2[x,]!="")) })==ncol(df2)),]
  wbp <- pptx(template = system.file("data","chem_rich_temp.pptx", package = "ChemRICH" ))
  pcamat <- do.call("cbind",lapply(df2,as.numeric))
  pcamat[which(is.na(pcamat)==TRUE)] <- min(pcamat[which(is.na(pcamat)==FALSE)])
  pcamat[which(is.na(pcamat)==TRUE)] <- 1
  pca.res <- mixOmics::pca(pcamat, ncomp=2,max.iter=100,center = T, scale = T)
  pc_scores <- pca.res$loadings[[1]]

  data_bw <- data.frame(sample= as.character(sapply(df1[1,-1], function(x) {as.character(x)}))  , class=tolower(as.character(sapply(df1[2,-1], function(x) {as.character(x)}))), PC1 = pc_scores[,1], PC2=pc_scores[,2])
  data_bw$PC1 <- as.numeric(pc_scores[,1])
  data_bw$PC2 <- as.numeric(pc_scores[,2])

  f2 <- ggplot(data_bw, aes(PC1,PC2)) +
    scale_y_continuous(paste("PC2 - variance explained : ",signif(pca.res$explained_variance[2],digit=4),"(%) ",sep="")) +
    scale_x_continuous(paste("PC1 - variance explained : ",signif(pca.res$explained_variance[1],digit=4),"(%) ",sep="")) +
    theme_bw() +
    labs(title = "Principal component analysis (PCA)") +
    theme(
      plot.title = element_text(face="bold", size=50),
      axis.title.x = element_text(face="bold", size=40),
      axis.title.y = element_text(face="bold", size=40, angle=90),
      panel.grid.major = element_blank(), # switch off major gridlines
      panel.grid.minor = element_blank(), # switch off minor gridlines
      panel.background = element_rect(fill = "transparent",colour = NA), # or theme_blank()
      plot.background = element_rect(fill = "transparent",colour = NA),
      #legend.position = c(0.3,0.8), # manually position the legend (numbers being from 0,0 at bottom left of whole plot to 1,1 at top right)
      legend.title = element_blank(), # switch off the legend title
      legend.text = element_text(size=40),
      legend.key.size = unit(1.5, "lines"),
      legend.key = element_blank(), # switch off the rectangle around symbols in the legend
      legend.spacing = unit(.05, "cm"),
      axis.text.x = element_text(size=0,angle = 45, hjust = 1),
      axis.text.y = element_text(size=0,angle = 45, hjust = 1)
    )
  f3 <- f2 + geom_point(aes_string(shape=colnames(data_bw)[2], colour=colnames(data_bw)[2] ), size=10)
  f4 <- f3 +  stat_ellipse( aes_string(colour=colnames(data_bw)[2] ), linetype = 1 )
  #plot(f4)
  wbp <- addSlide( wbp, "lipidClust" )
  wbp <- addPlot( wbp, function( ) print( f4 ), offx =2.5 , offy = 1.1, width = 25, height = 15 , vector.graphic = TRUE )
  wbp <- addParagraph( wbp, value = c("Principal component analysis shows that there is a clear difference in the two groups compared.") )
  writeDoc( wbp, file = paste0("wcmc_pca.pptx") )
}











