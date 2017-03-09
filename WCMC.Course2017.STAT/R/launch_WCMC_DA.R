# install_Stat_PCA <- function() {
#   devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.PCA")
#   # child pkg 2
#   # chld pkg 3
#   opencpu::opencpu$browse("library/WCMC.Course2017.STAT/www")
# }

update_childs <- function() {
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.mTIC",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.SampleSpecific",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Quantile",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.PQN",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Contrast",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.log",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Power",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Normalization.Scale",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.tTest",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.PairedTTest",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.OneWayANOVA",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.OneWayRepANOVA",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.TwoWayANOVA",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.TwoWayRepANOVA",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.TwoWayMixedANOVA",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.FoldChanges",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.Boxplot",force=T)
  devtools::install_github("slfan2013/WCMC_DA/WCMC.Stat.PCA",force=T)
}
