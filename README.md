# WCMC_DA
This package is for West Coast Metabolomics Center 2017 Summer Course.
## To Install:
```
#Install dependency packages.
install.packages('devtools', repos="http://cran.rstudio.com/")
library(devtools)
install.packages('opencpu')
library(opencpu)
install.packages("pacman")

#Install WCMC_DA
devtools::install_github("slfan2013/WCMC_DA/WCMC.MasterController")
WCMC.MasterController:update_master()
WCMC.Course2017.STAT::update_childs()
```

## To Launch:
```
library(opencpu);
opencpu$browse("library/WCMC.Course2017.STAT/www");
```

## To update to the newest version (automaticallly skip non-updated files): 
```
WCMC.MasterController:update_master()
WCMC.Course2017.STAT::update_childs()
```
