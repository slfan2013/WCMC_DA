FiehnLabFormat = function(input){

  pacman::p_load(data.table,stringr)

  input = gsub("\r","",input)
  cfile = strsplit(input,"\n")[[1]]

  ts = sapply(regmatches(cfile, gregexpr("\t", cfile)),length)
  t.mode = unique(ts)[which.max(tabulate(match(ts, unique(ts))))]
  ts.first.row = ts[1]
  cfile[[1]] = paste0(paste0(rep('\t',t.mode-ts.first.row),collapse = ''),cfile[[1]],collapse = '')


  df1 = as.data.frame(do.call(rbind,lapply(cfile,function(x){
    # if "BinBase name\tret.index\tquant mz\tBB id\tmass spec\tPubChem\tKEGG\tInChI Key\t", then last \t would be excluded.
    if(str_sub(x,-1,-1)=="\t"){
      x = paste0(x,"\t")
    }
    strsplit(x,"\t")[[1]]
  })),stringsAsFactors = F)

  if(t.mode==ts.first.row){
    col_start = which(diff(as.character(df1[1,])=='')==-1)[1] + 1
  }else{
    col_start = t.mode-ts.first.row + 1
  }
  row_start = which(diff(df1[,1]=='')==-1)[1] + 1



  if(length(row_start)==0 & col_start ==1){
    row_start = 1
  }else if(length(row_start)==0){
    stop("There is an error in the input format. Please click the '!' icon (next to 'Example Data File') for more information.")
  }

  p = t(df1[1:(row_start-1),col_start:ncol(df1)])
  colnames(p) = p[1,]
  p = cbind(data.frame("sample label" = c(1,as.character(df1[row_start,(col_start+1):ncol(df1)])),check.names = FALSE,
                       stringsAsFactors = F),
            p,stringsAsFactors=F)[-1,]
  if(sum(duplicated(as.character(df1[row_start,(col_start+1):ncol(df1)])))>0){
    rownames(p) = 1:nrow(p)
  }else{
    rownames(p) = as.character(df1[row_start,(col_start+1):ncol(df1)])
  }

  p = data.frame(p,stringsAsFactors = F,check.names = F)
  write.csv(p,"p.csv")

  f = df1[row_start:nrow(df1),1:col_start]

  if(class(f) == "character"){ #in case there is only one column of feature index.
    name.temp = f[1]
    f = data.frame(f[-1])
    colnames(f) = name.temp
  }else{
    colnames(f) = f[1,]
    f = f[-1,]
  }
  rownames(f) = 1:nrow(f)
  f[[length(f)]] = make.names(f[[length(f)]],unique = T)


  write.csv(f,"f.csv")

  e = df1[(row_start+1):nrow(df1),(col_start+1):ncol(df1)]
  e = apply(e,2,as.numeric)
  colnames(e) = rownames(p)
  rownames(e) = rownames(f)
  write.csv(e,"e.csv")

  return(list(
    e=e,
    f=f,
    p=p
  ))
}

