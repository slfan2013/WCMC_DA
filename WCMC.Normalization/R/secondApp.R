# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
secondApp = function(input){
  library(pacman)
  pacman::p_load(data.table,stringr)

  input <- gsub("\r","",input)

  data = WCMC.Fansly::FiehnLabFormat(input)
  e = data$e
  f = data$f
  p = data$p




  return(list(
    colnames_p = colnames(p),
    colnames_f = colnames(f),
    nrow_f = nrow(f)
  ))


}
