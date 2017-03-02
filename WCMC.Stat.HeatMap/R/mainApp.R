# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   scale = T,
                   distance_method = "euclidean",
                   minkowski_p = NULL, # only used when minkowski is used.
                   cluster_method = "complete",
                   row_col = "treatment",
                   row_branchColorNumber = 2,

                   col_col = NULL,
                   col_branchColorNumber = 1
                   ){
  library(pacman)
  pacman::p_load(data.table,parallel, ez, userfriendlyscience,dendextend,
                 colorspace,gplots,stringr)

  data. = WCMC.Fansly::FiehnLabFormat(input)
  e = data.$e
  f = data.$f
  p = data.$p

  # e = fread("C:\\Users\\Sili Fan\\Desktop\\WORK\\WCMC\\projects\\mx 300486_Ganeshan\\e.csv")[,-1]
  # f = fread("C:\\Users\\Sili Fan\\Desktop\\WORK\\WCMC\\projects\\mx 300486_Ganeshan\\f.csv")[,-1]
  # p = fread("C:\\Users\\Sili Fan\\Desktop\\WORK\\WCMC\\projects\\mx 300486_Ganeshan\\p.csv")[,-1]



  # get the data_row
  if(scale){
    data_row = scale(t(e))
  }else{
    data_row = t(e)
  }

  rownames(data_row) = p$`sample index`
  d_e <- dist(data_row, method = distance_method)
  hc_iris_row <- hclust(d_e, method = cluster_method)
  iris_species <- rev(levels(as.factor(p[[row_col]])))

  dend_row <- as.dendrogram(hc_iris_row)
  # order it the closest we can to the order of the observations:
  dend_row <- rotate(dend_row, 1:nrow(p))

  # Branch Color
  dend_row <- color_branches(dend_row, k=row_branchColorNumber) #, groupLabels=iris_species)

  # Label Color
  labels_colors(dend_row) <-
    rainbow_hcl(row_branchColorNumber)[sort_levels_values(
      as.numeric(as.factor(p[[row_col]]))[order.dendrogram(dend_row)]
    )]


    # Change Label
    labels(dend_row) <- paste(as.character(p[[row_col]])[order.dendrogram(dend_row)],
                          "(",p$`sample index`,")",
                          sep = "")

  # Hang
  # dend_row <- hang.dendrogram(dend_row,hang = 0.1)

  # Label Size
  dend_row <- set(dend_row, "labels_cex", 0.3)

  pdf(file = "Dendrogram_Sample.pdf")
  plot(dend_row,
       main = "Clustered Samples",
       horiz =  TRUE,  nodePar = list(cex = .007))
  legend("topleft", legend = iris_species, fill = rainbow_hcl(row_branchColorNumber))
  dev.off()

  # column dend.
  {
    if(scale){
      data_col = scale(as.matrix(e))
    }else{
      data_col = as.matrix(e)
    }

    rownames(data_col) = f[[1]]
    d_e <- dist(data_col, method = distance_method)
    hc_iris_col <- hclust(d_e, method = cluster_method)
    iris_species <- rev(levels(as.factor(p[[row_col]])))

    dend_col <- as.dendrogram(hc_iris_col)
    # order it the closest we can to the order of the observations:
    dend_col <- rotate(dend_col, 1:nrow(f))

    # Branch Color
    dend_col <- color_branches(dend_col, k=col_branchColorNumber) #, groupLabels=iris_species)

    # Label Color

    labels_colors(dend_col) <-
      rainbow_hcl(col_branchColorNumber)[sort_levels_values(
        as.numeric(as.factor(f[[col_col]]))[order.dendrogram(dend_col)]
      )]




    # Change Label
    labels(dend_col) <- paste(as.character(f[[col_col]])[order.dendrogram(dend_col)],
                              "(",f[[1]],")",
                              sep = "")

    # Hang
    # dend_col <- hang.dendrogram(dend_col,0.1)

    # Label Size
    dend_col <- set(dend_col, "labels_cex", 0.1)


    pdf(file = "Dendrogram_Compound.pdf",height = 14)
    plot(dend_col,
         main = "Clustered On Compounds",
         horiz =  T,  nodePar = list(cex = .007))
    legend("topleft", legend = iris_species, fill = rainbow_hcl(col_branchColorNumber))
    dev.off()
  }




  # HEATMAP
  some_col_func <- function(n) rev(colorspace::heat_hcl(n, c = c(80, 30), l = c(30, 90),
                                                        power = c(1/5, 1.5)))
  order.dendrogram(dend_row)= 1:nrow(p)
  order.dendrogram(dend_col)= 1:nrow(f)

  png(filename = "HeatMap.png",
      width = 3000, height = 800, res = 72)
  gplots::heatmap.2(data_row,
                    main = "Heatmap for the Iris data set",
                    srtCol = 45,
                    dendrogram = "both",
                    Rowv = dend_row,
                    Colv = dend_col, # this to make sure the columns are not ordered
                    trace="none",
                    margins =c(10,10),
                    key.xlab = "sd",
                    denscol = "grey",
                    density.info = "density",
                    RowSideColors = labels_colors(dend_row), # to add nice colored strips
                    ColSideColors = labels_colors(dend_col), # to add nice colored strips
                    col = some_col_func,
                    colRow = labels_colors(dend_row),
                    labRow = labels(dend_row),
                    colCol = labels_colors(dend_col),
                    labCol = labels(dend_col),
                    cexCol = 1,
                    keysize =1
  )
  dev.off()

  cut_row = data.frame(cutree(hc_iris_row,k=row_branchColorNumber))
  colnames(cut_row) = paste0("Cut into ",row_branchColorNumber, " clusters")
  result_row = cbind(p,cut_row)

  cut_col = data.frame(cutree(hc_iris_col,k=col_branchColorNumber))
  colnames(cut_col) = paste0("Cut into ",col_branchColorNumber, " clusters")
  result_col = cbind(f,cut_col)


  fwrite(data.table(result_row),"Dendrogram_row.csv")
  fwrite(data.table(result_row),"Dendrogram_row.txt",sep = "\t")

  fwrite(data.table(result_col),"Dendrogram_col.csv")
  fwrite(data.table(result_col),"Dendrogram_col.txt",sep = "\t")

  # return(result)


}
