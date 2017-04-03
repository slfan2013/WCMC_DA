# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   twoway = TRUE,
                   factor_order1 = NULL, factor_order2 = NULL,
                   legend_position = 'topleft',
                   draw_single = T,compoundName = 'zymosterol',
                   jitter = TRUE,
                   colors = NULL){
  library(pacman)
  pacman::p_load(data.table,parallel, ez, userfriendlyscience,dendextend,
                 colorspace,gplots,stringr)

  data. = WCMC.Fansly::MetaboAnalystFormat(input,row_start = ifelse(twoway,3,2))
  e = data.$e
  f = data.$f
  p = data.$p

  if(twoway){
    p = p[,c(2,3)] # this makes the group1 the first column and the group2 2nd column.
  }else{
    name = colnames(p)[2]
    p = data.frame(p[,2])
    colnames(p) = name
  }


  # e = fread("e.csv")[,-1]
  # f = fread("f.csv")[,-1]
  # p = fread("p.csv")[,-1]

  e = as.matrix(e)

  # e = t(apply(e,1,function(x){
  #   x[is.na(x)] = 0.5*min(x,na.rm = T)
  #   return(x)
  # }))

  if(twoway){
    xlab = paste0(colnames(p)[1], " * " ,colnames(p)[2])
  }else{
    xlab = colnames(p)[1]
  }



  if(twoway){
    if(is.null(factor_order1)||is.na(factor_order1)){
      factor_order1 = unique(p[[1]])
    }else{
      factor_order1 = strsplit(factor_order1, ",")[[1]]
    }
    if(is.null(factor_order2)||is.na(factor_order2)){
      factor_order2 = unique(p[[2]])
    }else{
      factor_order2 = strsplit(factor_order2, ",")[[1]]
    }
    tot.n = length(factor_order1)*length(factor_order2)
    m=1
    at.x = vector()
    for(i in 1:(tot.n+length(factor_order2))){
      if(!(i%%(length(factor_order1)+1)==0)){
        at.x[m] = m
      }
      m=m+1
    }
    at.x = at.x[!is.na(at.x)]
    text.pos.x = seq((tot.n/length(factor_order2)+1)/2,tot.n,by = tot.n/length(factor_order2))
    text.pos.x = text.pos.x + 0:(length(text.pos.x)-1)

    if(draw_single){
      index=which(gsub(" ", "", f[[1]], fixed = TRUE)%in%gsub(" ", "", compoundName, fixed = TRUE))[1]
      oo = index
    }else{
      index=1:nrow(f)
      oo=1
    }

    for(j in index){

      data = data.frame(value = e[j,],group1 = factor(p[[1]],levels = factor_order1), group2 = factor(p[[2]],levels = factor_order2))
      if(!draw_single){
        png(paste0(j,'th_',f[j,1],'.png'), width = 800, height = 600)
      }else{
        png('singlePlot.png', width = 800, height = 600)
      }
      boxplot(value~group1*group2,data = data,notch=FALSE,col=colors,
              xaxt="n",at = at.x)
      if(jitter){
        stripchart(value ~ group1*group2, vertical = TRUE, data = data,
                   method = "jitter", add = TRUE, pch = 20, col = 'black',at=at.x)
      }
      title(main=f[[1]][j], sub=paste0("compound #: ", j),
            xlab=xlab, ylab='intensity')
      axis(1,at = text.pos.x, labels = F)# x axis
      text(x = text.pos.x, par("usr")[3]-0.1, labels = factor_order2, srt = 0, pos = 1, xpd = TRUE)
      if(!legend_position=='none'){
        legend(legend_position,
               factor_order1, fill=colors)
      }
     dev.off()
    }


  }else{
    if(is.null(factor_order1)||is.na(factor_order1)){
      factor_order1 = unique(p[[1]])
    }else{
      factor_order1 = strsplit(factor_order1, ",")[[1]]
    }

    if(draw_single){
      index=which(gsub(" ", "", f[[1]], fixed = TRUE)%in%gsub(" ", "", compoundName, fixed = TRUE))[1]
      oo = index
    }else{
      index=1:nrow(f)
      oo=1
    }

    for(j in index){
        data = data.frame(value = e[j,],group1 = factor(p[[1]],levels = factor_order1))
        if(!draw_single){
          png(paste0(j,'th_',f[j,1],'.png'), width = 800, height = 600)
        }else{
          png('singlePlot.png', width = 800, height = 600)
        }
        boxplot(value~group1,data = data,notch=FALSE,col=colors,
                xaxt="n")
        if(jitter){
          stripchart(value ~ group1, vertical = TRUE, data = data,
                     method = "jitter", add = TRUE, pch = 20, col = 'black')
        }
        title(main=f[[1]][j], sub=paste0("compound #: ", j),
              xlab=xlab, ylab='intensity')
        axis(1,at = 1:length(factor_order1), labels = F)# x axis
        text(x = 1:length(factor_order1), par("usr")[3]-0.1, labels = factor_order1, srt = 0, pos = 1, xpd = TRUE)
        legend(legend_position,
               factor_order1, fill=colors)

          dev.off()

    }

  }


  if(!draw_single){
    zip("Boxplots.zip",files = paste0(1:nrow(f),"th_",f[[1]],".png"))
  }
}
