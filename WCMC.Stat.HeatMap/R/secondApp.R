# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
secondApp = function(input){
  library(pacman)
  pacman::p_load(data.table,stringr)

  data. = WCMC.Fansly::FiehnLabFormat(input)
  e = data.$e
  f = data.$f
  p = data.$p

  # e = fread("C:\\Users\\Sili Fan\\Desktop\\WORK\\WCMC\\projects\\mx 300486_Ganeshan\\e.csv")[,-1]
  # f = fread("C:\\Users\\Sili Fan\\Desktop\\WORK\\WCMC\\projects\\mx 300486_Ganeshan\\f.csv")[,-1]
  # p = fread("C:\\Users\\Sili Fan\\Desktop\\WORK\\WCMC\\projects\\mx 300486_Ganeshan\\p.csv")[,-1]

  return(list(
    colnames_p = colnames(p),
    colnames_f = colnames(f)
  ))


}
