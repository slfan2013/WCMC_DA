# install_Stat_PCA <- function() {
#   devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.PCA")
#   # child pkg 2
#   # chld pkg 3
#   opencpu::opencpu$browse("library/WCMC.Course2017.STAT/www")
# }

update_childs <- function() {
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.mTIC")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.SampleSpecific")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Quantile")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.PQN")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Contrast")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.log")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Power")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Scale")
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.TTest")
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
}
