# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   pvaluecrit = 0.1,
                   foldchangecrit=2){
  library(pacman)
  pacman::p_load(data.table,ggrepel)
  input <- gsub("\r","",input)
  cfile <- strsplit(input,"\n")[[1]]
  df1 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
  colnames(df1) = as.matrix(df1[1,])[1,]
  df1 = df1[-1,]
  colnames(df1) = c("label",'pvalue','foldchange')
  df1[,'pvalue'] = as.numeric(df1[,'pvalue'])
  df1[,'foldchange'] = as.numeric(df1[,'foldchange'])
  df = df1
  df[,'pvalue'] = -log10(as.numeric(df1[,'pvalue']))
  df[,'foldchange'] = log2(as.numeric(df1[,'foldchange']))

  df[!((df1$pvalue<pvaluecrit) & (df1$foldchange>foldchangecrit | df1$foldchange<1/foldchangecrit)),'label'] = ""


  df$selected = ifelse(!((df1$pvalue<pvaluecrit) & (df1$foldchange>foldchangecrit | df1$foldchange<1/foldchangecrit)),
                       "Not Important", "Important")

  if(sum(!df$label=="")==0){
    df$label[1] = "."
  }

  p <- ggplot(df, aes(foldchange, pvalue)) +
    geom_point(aes(color = selected)) +
    theme_classic(base_size = 10)+
    geom_text_repel(aes(label =label),size = 3.5)+
    labs(title="Volcano Plot",
         x ="Log2FoldChange", y = "-Log10pvalue")+
    geom_vline(xintercept = c(log2(1/foldchangecrit),log2(foldchangecrit)), linetype = "dotted")+
    geom_hline(yintercept = -log10(pvaluecrit), linetype = "dotted")+
    theme(legend.title=element_blank())

  ggsave("VolcanoPlot.png",p,width = 8, height = 6,dpi = 600)

}
