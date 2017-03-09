install = function(force=F){
  # if(!"WCMC.Stat.PCA" %in% rownames(installed.packages())){
    devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.PCA",force =force)
  # }
}
