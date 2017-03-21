# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
secondApp = function(input, twoway){
  library(pacman)
  pacman::p_load(data.table,stringr)

  row_start = ifelse(twoway, 3,2)

  data. = WCMC.Fansly::MetaboAnalystFormat(input,row_start = row_start)
  e = data.$e
  f = data.$f
  p = data.$p

  # e = fread("e.csv")[,-1]
  # f = fread("f.csv")[,-1]
  # p = fread("p.csv")[,-1]

  p = p[,c(2,3)] # this makes the group1 the first column and the group2 2nd column.




  return(list(
    factor_order1 = paste0(unique(p[[1]]),collapse = ','),
    factor_order2 = paste0(unique(p[[2]]),collapse = ','),
    compoundNames= f$`compound label`
  ))


}
