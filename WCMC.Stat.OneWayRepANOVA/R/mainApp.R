# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input, posthocNeeded = T){
  library(pacman)
  pacman::p_load(data.table,parallel,userfriendlyscience,ez)
  # read.data
  data. = WCMC.Fansly::MetaboAnalystFormat(input,row_start = 3)
  e = data.$e
  f = data.$f
  p = data.$p

  e = as.matrix(e)


  multicore = F
  if(multicore){
    cl = makeCluster(min(detectCores(),2))
  }else{
    cl = makeCluster(1)
  }

  ID = colnames(p)[3]
  group=colnames(p)[2]
  ANOVA = parSapply(cl,1:nrow(e),function(j,e,p,group,ezANOVA,ID,posthocNeeded){

    data = data.frame(value=e[j,],var2=p[[group]],id=as.factor(p[[ID]]))

    ANOVAp = ezANOVA(data = data,
            dv = value, wid = id,within = var2, type = 3)$`Sphericity Corrections`[1,"p[GG]"]
    # ANOVAp = NULL
    if(posthocNeeded){
      test.temp = pairwise.t.test(paired = T, x = data$value, g = data$var2, p.adjust.method  = "holm")$p.value
      post_hoc = as.numeric(test.temp)[!is.na(as.numeric(test.temp))]
    }else{
      post_hoc=NULL
    }

    return(c(ANOVAp, post_hoc))

  },e,p,group,ezANOVA,ID,posthocNeeded)

  if(posthocNeeded){
    ANOVA = t(ANOVA)
    data = data.frame(value=e[1,],var2=p[[group]],id=as.factor(p[[ID]]))
    colnames(ANOVA) = c("repANOVA p value",
                        paste0("pairwise-comparison: ",apply(combn(levels(data[,2]), 2),2,function(x){paste(x[1],x[2],sep="_vs_")})))
  }else{
    ANOVA = data.frame("repANOVA p value"= ANOVA)
  }



  # Greenhouse-Geisser adjusted one-way repeated measures ANOVA. Greenhouse & Geisser (1959)
  # The exercise intervention elicited statistically significant changes in CRP concentration over time, F(1.296, 11.663) = 26.938, p < .0005.
  # The exercise intervention did not lead to any statistically significant changes in CRP concentration over time, F(1.296, 11.663) = 1.256, p = .300.
  # It is suggested only use main effect when interaction term is NOT significant.



  if(!class(f)=='character'){
    f = f[,!sapply(f,function(x){sum(x=='')==length(x)})]
  }


  result = data.table(f,ANOVA)
  rownames(result) = 1:nrow(result)
  if(class(f)=="character"){
    colnames(result) = c('compound label',colnames(ANOVA))
  }else{
    colnames(result) = c(colnames(f),colnames(ANOVA))
  }

  fwrite(data.table(result),"OneWayRepANOVA.csv")
  fwrite(data.table(result),"OneWayRepANOVA.txt",sep = "\t")


  stopCluster(cl)

  return(result)


}
