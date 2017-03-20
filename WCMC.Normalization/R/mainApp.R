# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   normalizationMethodsSelection=c("None","mTIC","SampleSpecific","Quantile","PQN","contrast"),
                   sampleSpecificMethodsSelection=c('sum','median','mean'),
                   sampleSpecificWeight,
                   transformationMethodsSelection=c("None","log","power"),
                   logbase="exp(1)",
                   power=1/3,
                   scaleMethodsSelection=c("None","centering","auto",'parato','vast','level','range'),
                   PCA=TRUE,
                   Normality=TRUE,
                   RSD=TRUE){
  library(pacman)
  pacman::p_load(data.table,affy,WCMC.Fansly, dendextend,
                 colorspace,gplots,stringr,RColorBrewer,mvtnorm,factoextra,FactoMineR,xlsx)
  input <- gsub("\r","",input)

  data = WCMC.Fansly::FiehnLabFormat(input)
  e = data$e
  f = data$f
  p = data$p

  # e = fread("e.csv")
  # f = fread("f.csv")
  # p = fread("p.csv")

  e = as.matrix(e)

  normalizationList = list()
  for(normalization in normalizationMethodsSelection){
    if(normalization=='None'){
      e1 = e
      normalizationList[[normalization]] = e1
    }
    if(normalization=='mTIC'){
      sums = apply(e[f[["Known/Unknown"]]=='Known',],2,  sum, na.rm=T)
      mean_sums = mean(sums)
      e1 = t(t(e)/(sums/mean_sums))
      e1 = toSameScale(e,e1)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
    if(normalization=="SampleSpecific"){
      if("sum"%in%sampleSpecificMethodsSelection){
        sums = colSums(e,na.rm = T)
        e1 = t(t(e)/sums*mean(sums,na.rm = T))
        e1 = toSameScale(e,e1)
        rownames(e1) = rownames(e)
        colnames(e1) = colnames(e)
        normalizationList[["SampleSpecific_sum"]] = e1
      }
      if("median"%in%sampleSpecificMethodsSelection){
        medians = apply(e,2,median,na.rm = T)
        e1 = t(t(e)/medians*mean(medians,na.rm = T))
        e1 = toSameScale(e,e1)
        rownames(e1) = rownames(e)
        colnames(e1) = colnames(e)
        normalizationList[["SampleSpecific_median"]] = e1
      }
      if("mean"%in%sampleSpecificMethodsSelection){
        means = colMeans(e,na.rm = T)
        e1 = t(t(e)/means*mean(means,na.rm = T))
        e1 = toSameScale(e,e1)
        rownames(e1) = rownames(e)
        colnames(e1) = colnames(e)
        normalizationList[["SampleSpecific_mean"]] = e1
      }
      if("custom sample weight"%in%sampleSpecificMethodsSelection){
        # weight <- gsub("\r","",weight)
        # cfile <- strsplit(weight,"\n")[[1]]
        # df2 <- as.data.frame(do.call(rbind,lapply(cfile,function(x){strsplit(x,"\t")[[1]]})),stringsAsFactors = F)
        # colnames(df2) = as.matrix(df2[1,])[1,]
        # df2 = df2[-1,]
        # colnames(df2)[2:ncol(df2)] = colnames(df2)[1:(ncol(df2)-1)]
        # colnames(df2)[1] = 'column1'
        # df2 = df2[,c('column1',colnames(df1)[2:ncol(df1)])]
        # weight = as.numeric(df2[1,]);
        # weight = weight[!is.na(weight)]
        # e1 = t(t(e)*weight)
        e1 = toSameScale(e,e1)
        rownames(e1) = rownames(e)
        colnames(e1) = colnames(e)
        normalizationList[["SampleSpecific_customweight"]] = e1
      }
    }
    if(normalization=="Quantile"){
      normalize.quantile <- get("normalize.quantiles", en = asNamespace("affy"))
      e1 <- normalize.quantile(e)
      e1 = toSameScale(e,e1)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
    if(normalization=="PQN"){
      reference <- apply(e, 1, median,na.rm = T)
      quotient <- e / reference
      quotient.median <- apply(quotient, 2, median,na.rm = T)
      e1 <- t(t(e) / quotient.median)
      e1 = toSameScale(e,e1)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }
    if(normalization=="contrast"){
      #---First adaption: Make the e matrix non-negative
      threshold = 1e-11
      e[e <= 0] <- threshold
      #---Apply normalization
      maffy.e <- maffy.normalize(e, subset = 1:nrow(e), span = 0.75,
                                    verbose = TRUE,
                                    family = "gaussian", log.it = FALSE)
      #---Second adaption: Subtract 10% Quantile from each sample
      subtract <- function(x) {
        t(t(x) - apply(x, 2, quantile, 0.1,na.rm=T))
      }
      e1 <- subtract(maffy.e)
      e1 = toSameScale(e,e1)
      rownames(e1) = rownames(e)
      colnames(e1) = colnames(e)
      normalizationList[[normalization]] = e1
    }

  }

  transformationList = list()
  for(i in 1:length(normalizationList)){
    e1 = normalizationList[[i]]
    if("None"%in%transformationMethodsSelection){
      e2 = e1
      rownames(e2) = rownames(e)
      colnames(e2) = colnames(e)
      transformationList[[paste0(names(normalizationList)[i],"_None")]] = e2
    }
    if("log"%in%transformationMethodsSelection){
      e2 = log(e1+1,base = eval(parse(text=logbase)))
      rownames(e2) = rownames(e)
      colnames(e2) = colnames(e)
      transformationList[[paste0(names(normalizationList)[i],"_log")]] = e2
    }
    if("power"%in%transformationMethodsSelection){
      e2 = (e1+1)^eval(parse(text=power))
      rownames(e2) = rownames(e)
      colnames(e2) = colnames(e)
      transformationList[[paste0(names(normalizationList)[i],"_power")]] = e2
    }
  }

  scaleList = list()#"None","centering","auto",'parato','vast','level','range'
  for(i in 1:length(transformationList)){
    e2 = transformationList[[i]]
    if("None"%in%scaleMethodsSelection){
      e3 = e2
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_None")]] = e3
    }
    if("centering"%in%scaleMethodsSelection){
      e3 = t(scale(t(e2),scale = F))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_centering")]] = e3
    }
    if("auto"%in%scaleMethodsSelection){
      e3 = t(scale(t(e2)))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_auto")]] = e3
    }
    if("parato"%in%scaleMethodsSelection){
      e3 = t(scale(t(e2),scale = apply(t(e2),2,function(x){sqrt(sd(x,na.rm = T))})))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_parato")]] = e3
    }
    if("vast"%in%scaleMethodsSelection){
      e3. = t(scale(t(e2),scale = T))
      e3 = e3. * (apply(e2,1,function(x){mean(x,na.rm = T)/sd(x,na.rm = T)}))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_vast")]] = e3
    }
    if("level"%in%scaleMethodsSelection){
      mean. = rowMeans(e2,na.rm=T)
      e3 = (e2 - mean.)/mean.
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_level")]] = e3
    }
    if("range"%in%scaleMethodsSelection){
      e3 = t(apply(e2,1,function(x){
        (x - mean(x))/diff(range(x))
      }))
      rownames(e3) = rownames(e)
      colnames(e3) = colnames(e)
      scaleList[[paste0(names(transformationList)[i],"_range")]] = e3
    }
  }

  if(PCA){
    dir.create("PCA")
    dir.create("PCA/scores")
    dir.create("PCA/plots")
    PCAs = list()
    for(i in 1:length(scaleList)){
      scaleList[[i]] = t(apply(scaleList[[i]],1,function(x){
        x[is.na(x)]=median(x,na.rm = T)
        x
      }))
      res.pca <- prcomp(t(scaleList[[i]]),center = F, scale. = F)
      if(length(unique(p[["PCA_color"]]))<2){
        PCAs[[i]]=fviz_pca_ind(res.pca,addEllipses = TRUE, ellipse.level = 0.95,repel=T,axes = c(1,2),
                           res = 150,geom="point",title=names(scaleList)[i]) +
                theme_minimal()
      }else{
        PCAs[[i]]=fviz_pca_ind(res.pca,
                           habillage = p[["PCA_color"]], addEllipses = TRUE, ellipse.level = 0.95,repel=T,axes = c(1,2),
                           res = 150,geom="point",title=names(scaleList)[i],axes.linetype = "dotted") +
                theme_minimal()
      }
      fwrite(data.table(res.pca$x),paste0("PCA/scores/",names(scaleList)[i],"_PCAscore.csv"))
    }
    for(i in 1:length(PCAs)){
      png(filename = paste0("PCA/plots/",names(scaleList)[i],".png"),width=400,height=400)
      print(PCAs[[i]])
      dev.off()
    }
  }

  if(Normality){
    dir.create("Normality")
    Normalitys = list()
    for(i in 1:length(scaleList)){
      Normalitys[[i]]=apply(scaleList[[i]],1,function(x){
        shapiro.test(lm(x~p$Normality_factor)$res)$p.value
      })
    }

    plevel = sapply(Normalitys, function(x){
      as.character(cut(x,c(-1,0.05,1),labels=c("Reject Normality","Failt to reject Normality")))
    })
    plevel = factor(plevel,levels = c("Reject Normality","Failt to reject Normality"))
    Normalizatio.methods = rep(names(scaleList),each=nrow(e))
    Normalizatio.methods = factor(Normalizatio.methods,levels=names(scaleList))
    stackHist = data.frame("Normalization methods" = Normalizatio.methods,
                           "test level" = plevel)
    ggplot(stackHist,aes(x = Normalizatio.methods))+
      geom_bar(aes(fill=test.level),color="black")+
      theme_minimal()+ theme(axis.text.x = element_text(angle = 90, hjust = 1))
    ggsave("Normality/NormalityTest.png",height=8,width =12)

    fwrite(data.table(do.call("cbind",Normalitys)),"Normality/Normality.csv")
  }



  if(RSD){
    dir.create("RSD")
    RSDs = list()
    scaleList. = scaleList[grepl("_None_None",names(scaleList))]
    names(scaleList.) = gsub("_None_None","",names(scaleList.))
    for(i in 1:length(scaleList.)){
      RSDs[[i]]=apply(scaleList.[[i]],1,function(x){
        x. = x[p$RSD]
        sd(x.,na.rm = T)/mean(x.,na.rm = T)
      })
    }

    RSD.table = data.table(do.call("cbind",RSDs))
    RSD.table = cbind(data.table(f$`compound label`),RSD.table)
    colnames(RSD.table) = c("compound label",names(scaleList.))
    fwrite(RSD.table,"RSD/RSD.csv")

    RSD. = sapply(RSDs,median,na.rm=T)
    names(RSD.) = names(scaleList.)
    RSD. = sort(RSD.,decreasing = T)
    bar.ggplot2 = data.frame(RSD = signif(RSD.,3),methods = factor(names(RSD.),levels = names(RSD.)))

    ggplot(bar.ggplot2, aes(x = methods, y = RSD.)) + geom_bar(stat = "identity",fill = c(rep("black",length(RSD.)-1),"red"))+
      theme(text = element_text(size=10),axis.text.x = element_text(angle=90, hjust=1))+
      geom_text(aes(label=RSD), vjust=-.5, colour="black")+ggtitle("Median of QC RSD")+theme(
        plot.title = element_text(size = rel(1.2), hjust = 0.5,face = 'bold',family = "Arial"),#title size.
        axis.text	 = element_text(colour = 'black'),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.key = element_rect(fill = "white",colour = "white"),
        legend.title = element_text(face = 'bold'),
        text=element_text(family="Arial")
      )
    ggsave("RSD/QC performance plot2.png",width = 6, height = 6)
  }



}





















