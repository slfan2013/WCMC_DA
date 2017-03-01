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
                   row_branchColorNumber = 2
                   ){
  library(pacman)
  pacman::p_load(data.table,parallel, ez, userfriendlyscience,dendextend,
                 colorspace,gplots)

  # get the data.

  # if(scale){
  #   data = scale(t(e))
  # }else{
  #   data = t(e)
  # }
  #
  #
  # data = data[order(as.factor(p[[row_col]])),]
  # p = p[order(as.factor(p[[row_col]])),]
  # rownames(data) = 1:nrow(data)
  # d_e <- dist(data, method = distance_method)
  # hc_iris <- hclust(d_e, method = cluster_method)
  # iris_species <- rev(levels(as.factor(p[[row_col]])))
  #
  # dend <- as.dendrogram(hc_iris)
  # # order it the closest we can to the order of the observations:
  # dend <- rotate(dend, 1:nrow(p))
  #
  # # Branch Color
  # dend <- color_branches(dend, k=row_branchColorNumber) #, groupLabels=iris_species)
  #
  # # Label Color
  # labels_colors(dend) <-
  #   rainbow_hcl(row_branchColorNumber)[sort_levels_values(
  #     as.numeric(as.factor(p[[row_col]]))[order.dendrogram(dend)]
  #   )]
  #
  #
  #   # Change Label
  #   labels(dend) <- paste(as.character(p$treatment)[order.dendrogram(dend)],
  #                         "(",p$`sample label`,")",
  #                         sep = "")
  #
  # # Hang
  # # dend <- hang.dendrogram(dend)
  #
  # # Label Size
  # dend <- set(dend, "labels_cex", 0.5)
  #
  # # par(mar = c(3,3,3,7))
  # plot(dend,
  #      main = "Clustered Iris data set
  #      (the labels give the true flower species)",
  #      horiz =  TRUE,  nodePar = list(cex = .007))
  # legend("topleft", legend = iris_species, fill = rainbow_hcl(row_branchColorNumber))
  #
  #
  #
  # # HEATMAP
  # some_col_func <- function(n) rev(colorspace::heat_hcl(n, c = c(80, 30), l = c(30, 90),
  #                                                       power = c(1/5, 1.5)))
  # order.dendrogram(dend)= 1:nrow(p)
  # gplots::heatmap.2(data,
  #                   main = "Heatmap for the Iris data set",
  #                   srtCol = 20,
  #                   dendrogram = "both",
  #                   Rowv = dend,
  #                   Colv = T, # this to make sure the columns are not ordered
  #                   trace="none",
  #                   margins =c(5,5),
  #                   key.xlab = "sd",
  #                   denscol = "grey",
  #                   density.info = "density",
  #                   RowSideColors = labels_colors(dend), # to add nice colored strips
  #                   col = some_col_func,
  #                   colRow = labels_colors(dend),
  #                   labRow = labels(dend)
  # )
  #
  #
  #
  #
  # fwrite(data.table(result),"HeatMap.csv")
  # fwrite(data.table(result),"HeatMap.txt",sep = "\t")

  # {
  #   input = gsub("\r","",input)
  #   cfile = strsplit(input,"\n")[[1]]
  #
  #   ts = sapply(regmatches(cfile, gregexpr("\t", cfile)),length)
  #   t.mode = unique(ts)[which.max(tabulate(match(ts, unique(ts))))]
  #   ts.first.row = ts[1]
  #   cfile[[1]] = paste0(paste0(rep('\t',t.mode-ts.first.row),collapse = ''),cfile[[1]],collapse = '')
  #
  #
  #   df1 = as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
  #
  #   if(t.mode==ts.first.row){
  #     col_start = which(diff(as.character(df1[1,])=='')==-1) + 1
  #   }else{
  #     col_start = t.mode-ts.first.row + 1
  #   }
  #   row_start = which(diff(df1[,1]=='')==-1) + 1
  #   if(length(row_start)==0 & col_start ==1){
  #     row_start = 1
  #   }else if(length(row_start)==0){
  #     stop("There is an error in the input format. Please click the '!' icon (next to 'Example Data File') for more information.")
  #   }
  #
  #   p = t(df1[1:(row_start-1),col_start:ncol(df1)])
  #   colnames(p) = p[1,]
  #   p = cbind(data.frame("sample index" = c(1,as.character(df1[row_start,(col_start+1):ncol(df1)])),check.names = FALSE,
  #                        stringsAsFactors = F),
  #             p,stringsAsFactors=F)[-1,]
  #
  #   rownames(p) = df1[row_start,(col_start+1):ncol(df1)]
  #   p = data.frame(p,stringsAsFactors = F,check.names = F)
  #   # write.csv(p,"p.csv")
  #
  #   f = df1[row_start:nrow(df1),1:col_start]
  #
  #   if(class(f) == "character"){ #in case there is only one column of feature index.
  #     name.temp = f[1]
  #     f = data.frame(f[-1])
  #     colnames(f) = name.temp
  #   }else{
  #     colnames(f) = f[1,]
  #     f = f[-1,]
  #   }
  #   rownames(f) = 1:nrow(f)
  #
  #   # write.csv(f,"f.csv")
  #
  #   e = df1[(row_start+1):nrow(df1),(col_start+1):ncol(df1)]
  #   e = apply(e,2,as.numeric)
  #   colnames(e) = rownames(p)
  #   rownames(e) = rownames(f)
  # }

  # result = list(e = e, p =p, f=f)
  result = input
  return(result)


}
