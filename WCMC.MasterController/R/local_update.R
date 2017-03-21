foo = function(){
  purl <- "http://wcmc-da.fiehnlab.ucdavis.edu/ocpu/library/devtools/R/install_github"

  library(RCurl)
  library(jsonlite)


  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Course2017.STAT",force=T)))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Fansly")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.mTIC")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.SampleSpecific")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.Quantile")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.PQN")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.Contrast")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.log")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.Power")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.Scale")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.tTest")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.PairedTTest")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.OneWayANOVA")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.OneWayRepANOVA")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.TwoWayANOVA")))
  # getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.TwoWayRepANOVA")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.TwoWayMixedANOVA")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.FoldChanges")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.Boxplot")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.PCA")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.VolcanoPlot")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Stat.HeatMap")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.Batch")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization.LOESS")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="slfan2013/WCMC_DA/WCMC.Normalization")))
  getURL(purl,customrequest='POST',httpheader=c('Content-Type'='application/json'),postfields=toJSON(list(repo="barupal/metamapp")))




  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.mTIC")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.SampleSpecific")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Quantile")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.PQN")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Contrast")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.log")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Power")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Scale")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.tTest")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.PairedTTest")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.OneWayANOVA")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.OneWayRepANOVA")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.TwoWayANOVA")
  # devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.TwoWayRepANOVA")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.TwoWayMixedANOVA")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.FoldChanges")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.Boxplot")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.PCA")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.VolcanoPlot")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.HeatMap")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Batch")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.LOESS")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization")
  devtools::install_github("barupal/metamapp")















  getURL("http://wcmc-da.fiehnlab.ucdavis.edu/ocpu/library/pacman/R/p_load",customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(char="RCurl")))

  getURL("http://wcmc-da.fiehnlab.ucdavis.edu/ocpu/library/pacman/R/p_load",customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(char="tidyr")))
  getURL("http://wcmc-da.fiehnlab.ucdavis.edu/ocpu/library/pacman/R/p_load",customrequest='POST',httpheader=c('Content-Type'='application/json'),
         postfields=toJSON(list(char="ez")))




  RCurl::getURL("http://wcmc-da.fiehnlab.ucdavis.edu/ocpu/library/utils/R/install.packages",customrequest='POST',httpheader=c('Content-Type'='application/json'),
                postfields=jsonlite::toJSON(list(pkgs="plyr")))





  for(i in rownames(installed.packages())){
    RCurl::getURL("http://wcmc-da.fiehnlab.ucdavis.edu/ocpu/library/utils/R/install.packages",customrequest='POST',httpheader=c('Content-Type'='application/json'),
                  postfields=jsonlite::toJSON(list(pkgs="RCurl")))
    print(i)
  }












}
