# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
test = function(){

  A = matrix(rnorm(5 * 10), nrow = 5)


  A = scale(A)

  pca = prcomp(A)


  pca$rotation



  return(result)
}


A = matrix(c(0.28864296586786903,0.09735046643370852,-0.06878530418304919,-0.020408302001974694),nrow=2,byrow = T)



B= A
B[,1] = B[,1]*0.00001
scale(B)[,1]

A = matrix(c(1,2,3,4,5,6,7,3,9),byrow=T,nrow=3)

svd(A)$u %*% diag(svd(A)$d)

prcomp(A,center = F,scale. = F)$x
prcomp(A,center = F,scale. = F)$rotation
