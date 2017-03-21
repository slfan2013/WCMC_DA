# Metabox
This package is for West Coast Metabolomics Center 2017 Summer Course Statistics Part.


cite:
Wanichthanarak K, Fan S, Grapov D, Barupal DK, Fiehn O. Metabox: A Toolbox for Metabolomic Data Analysis, Interpretation and Integrative Exploration. PloS one. 2017 Jan 31;12(1):e0171046.

Software requirement: [R](https://www.r-project.org/about.html) (and [RTools](https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows) for Windows Users).
## To Install:
```
shell("zip") # Some packages ask for zip. If error returns, visit https://cran.r-project.org/web/packages/openxlsx/vignettes/Introduction.pdf.
#Install dependency packages.
install.packages('devtools', repos="http://cran.rstudio.com/")
library(devtools)
install.packages('opencpu')
library(opencpu)
install.packages("pacman")

#Install WCMC_DA
install.packages("https://github.com/slfan2013/WCMC_DA/raw/master/WCMC.MasterController_0.1.0.tar.gz",repos=NULL)
WCMC.MasterController::update_master()
WCMC.Course2017.STAT::update_childs()
```

## To Launch:
```
library(opencpu);
opencpu$browse("library/WCMC.Course2017.STAT/www");
```

## To update to the newest version: 
```
WCMC.MasterController::update_master()
WCMC.Course2017.STAT::update_childs()
```
## To Report Bugs or Provide Suggestions:
Please go to https://github.com/slfan2013/WCMC_DA/issues OR contact the maintainer through email, slfan at ucdavis dot edu, and thanks for your contribution.


#### please note that the first time running will be slow depending on the internet because it needs to download all the dependency packages. 

This package is built as a wrapper of [metabox](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0171046) [code](https://github.com/kwanjeeraw/metabox).
