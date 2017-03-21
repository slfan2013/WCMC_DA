foo = function(){
  purl <- "http://wcmc-da.fiehnlab.ucdavis.edu/ocpu/library/utils/R/install.packages"

  library(RCurl)
  library(jsonlite)


  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Course2017.STAT_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Fansly_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.mTIC_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.SampleSpecific_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Quantile_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.PQN_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Contrast_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.log_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Power_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Scale_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.tTest_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.PairedTTest_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.OneWayANOVA_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.OneWayRepANOVA_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.TwoWayANOVA_0.1.0.tar.gz")))
  # getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
  # postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.TwoWayRepANOVA_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.TwoWayMixedANOVA_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.FoldChanges_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.Boxplot_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.PCA_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.VolcanoPlot_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.HeatMap_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Batch_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.LOESS_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization_0.1.0.tar.gz")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(pkgs="barupal/metamapp",repos=NULL)))




  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.mTIC_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.SampleSpecific_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Quantile_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.PQN_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Contrast_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.log_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Power_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Scale_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.tTest_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.PairedTTest_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.OneWayANOVA_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.OneWayRepANOVA_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.TwoWayANOVA_0.1.0.tar.gz",repos=NULL)
  # install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.TwoWayRepANOVA_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.TwoWayMixedANOVA_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.FoldChanges_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.Boxplot_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.PCA_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.VolcanoPlot_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Stat.HeatMap_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.Batch_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization.LOESS_0.1.0.tar.gz",repos=NULL)
  install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.Normalization_0.1.0.tar.gz",repos=NULL)
  devtools::install_github("barupal/metamapp")
}
