MetaboAnalystFormat = function(input, row_start =3){
  input = gsub("\r","",input)
  cfile = strsplit(input,"\n")[[1]]
  df1 = as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)



  p = t(df1[1:(row_start-1),1:ncol(df1)])
  colnames(p) = p[1,]
  p = cbind(data.frame("sample label" = c(1,as.character(df1[row_start,(1+1):ncol(df1)])),check.names = FALSE,
                       stringsAsFactors = F),
            p,stringsAsFactors=F)[-1,]

  rownames(p) = df1[row_start,(1+1):ncol(df1)]
  p = data.frame(p,stringsAsFactors = F,check.names = F)



  f = data.frame(df1[(row_start+1):nrow(df1),1])
  colnames(f) = "compound label"


  e = df1[(row_start+1):nrow(df1),2:ncol(df1)]
  e = apply(e,2,as.numeric)
  colnames(e) = p$`sample label`
  rownames(e) = f$`compound label`

  return(list(
    p = p,
    f = f,
    e = e
  ))




}
