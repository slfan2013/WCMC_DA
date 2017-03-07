# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
mainApp = function(input,
                   posthocNeeded = TRUE){
  library(pacman)
  pacman::p_load(data.table,parallel, ez, userfriendlyscience)
  # read.data
  {
    data.list = WCMC.Fansly::MetaboAnalystFormat(input=input, row_start = 4)
    p = data.list$p
    f = data.list$f
    e = data.list$e
  }

  e = as.matrix(e)
  # e = t(apply(e,1,function(x){
  #   x[is.na(x)] = 0.5*min(x,na.rm = T)+rnorm(sum(is.na(x)),mean=0,sd = 0.1)
  #   return(x)
  # }))


  multicore = T
  if(multicore){
    cl = makeCluster(min(detectCores(),20))
  }else{
    cl = makeCluster(1)
  }

  twowayMixedANOVA = parSapply(cl,1:nrow(e),function(j,e,p,ezANOVA){
    test = ezANOVA(data = data.frame(value=e[j,],var1=p[[2]],var2=p[[3]],id=as.factor(p[[4]])),
            dv = value, wid = id, between = .(var1),within=.(var2), type = 3)
    return(c(test$ANOVA[1,'p'],test$`Sphericity Corrections`[,'p[GG]']))
  },e,p,ezANOVA)
  rownames(twowayMixedANOVA) = c(paste0("ANOVA (",colnames(p)[2],")"), paste0("ANOVA (",colnames(p)[3], ")"), paste0(colnames(p)[c(2,3)], collapse = "*"))
  twowayMixedANOVA = t(twowayMixedANOVA[c(3,1,2),])

  if(posthocNeeded){# only simple main effect comparison.
    if(length(unique(p[[2]]))==2){# this means that the independent factor needs a t test.
      simpleMainEffect1.by = by(p,p[[3]],FUN = function(x){
                            # x=p[p[[3]]==p[[3]][1],]
                            e.=e[,p[[3]]%in%x[[3]]];p.=x;
                            t_test = parSapply(cl,1:nrow(e.),function(j,e.,p.){
                                      oneway.test(e.[j,] ~ as.factor(p.[[2]]), var.equal = FALSE)$p.value
                                    },e.,p.)
                            t_test_FDR = p.adjust(t_test,"fdr")
                            return(data.frame(t_test,t_test_FDR))
                          })
      simpleMainEffect1 = do.call(cbind,simpleMainEffect1.by)
      colnames(simpleMainEffect1) = rep(paste0(paste0(levels(as.factor(p[[2]])),collapse = " vs ")," @",names(simpleMainEffect1.by)),each=2)
      colnames(simpleMainEffect1) = paste0(colnames(simpleMainEffect1),rep(c(""," (FDR)"),ncol(simpleMainEffect1)/2))

    }else{
      simpleMainEffect1. = by(p,p[[3]],FUN=function(x){
        # x=p[p[[3]]==p[[3]][1],]
        e.=e[,p[[3]]%in%x[[3]]];p.=x
        ANOVA = parSapply(cl,1:nrow(e.),function(j,e.,p.,posthocTGH){
          paraANOVAposthoc = posthocTGH(e.[j,],as.factor(p.[[2]]),digits = 4)$output[["games.howell"]][,6]
          return(c(oneway.test(e.[j,] ~ as.factor(p.[[2]]), var.equal = FALSE)$p.value,paraANOVAposthoc))
        },e.,p.,posthocTGH)
        ANOVA = data.frame(t(ANOVA))
        colnames(ANOVA)=paste0(c(paste0("ANOVA (",colnames(p.)[2],")"),
                                 gsub("-"," vs ",rownames(posthocTGH(e.[1,],as.factor(p.[[2]]),digits = 4)$output[["games.howell"]]))),
                               paste0(" @",unique(p.[[3]])))
        return(ANOVA)
      })
      names(simpleMainEffect1.) = rep("",length(names(simpleMainEffect1.)))
      simpleMainEffect1 = do.call(cbind,simpleMainEffect1.)
    }

    if(length(unique(p[[3]]))==2){# this means that we need to do a paired t test on each level of p[[3]] and do a FDR cor.
      simpleMainEffect2.by = by(p,p[[2]],FUN = function(x){
        # x=p[p[[2]]==p[[2]][1],]
        e.=e[,p[[2]]%in%x[[2]]];p.=x;
        t_test = parSapply(cl,1:nrow(e.),function(j,e.,p.){
          t.test(e.[j,] ~ as.factor(p.[[3]]), var.equal = FALSE, paired = T)$p.value
        },e.,p.)
        t_test_FDR = p.adjust(t_test,"fdr")
        return(data.frame(t_test,t_test_FDR))
      })
      simpleMainEffect2 = do.call(cbind,simpleMainEffect2.by)
      colnames(simpleMainEffect2) = rep(paste0(paste0(levels(as.factor(p[[3]])),collapse = " vs ")," @",names(simpleMainEffect2.by)),each=2)
      colnames(simpleMainEffect2) = paste0(colnames(simpleMainEffect2),rep(c(""," (FDR)"),ncol(simpleMainEffect2)/2))

    }else{
      simpleMainEffect2. = by(p,p[[2]],FUN=function(x){
        # x=p[p[[2]]==p[[2]][1],]
        e.=e[,p[[2]]%in%x[[2]]];p.=x
        ANOVA = parSapply(cl,1:nrow(e.),function(j,e.,p.,posthocNeeded,ezANOVA){

          data = data.frame(value=e.[j,],var2=p.[[3]],id=as.factor(p.[[4]]))

          ANOVA.p = ezANOVA(data = data,
                            dv = value, wid = id,within = .(var2), type = 3)$`Sphericity Corrections`[1,"p[GG]"]

          if(posthocNeeded){
            test.temp = pairwise.t.test(paired = T, x = data$value, g = data$var2, p.adjust.method  = "holm")$p.value
            post_hoc = as.numeric(test.temp)[!is.na(as.numeric(test.temp))]
          }else{
            post_hoc=NULL
          }

          return(c(ANOVA.p, post_hoc))
        },e.,p.,posthocNeeded,ezANOVA)
        ANOVA = data.frame(t(ANOVA))
        colnames(ANOVA)=paste0(c(paste0("ANOVA (",colnames(p.)[3],")"),
                                 gsub("-"," vs ",rownames(posthocTGH(e.[1,],as.factor(p.[[3]]),digits = 4)$output[["games.howell"]]))),
                               paste0(" @",unique(p.[[2]])))
        return(ANOVA)
      })
      names(simpleMainEffect2.) = rep("",length(names(simpleMainEffect2.)))
      simpleMainEffect2 = do.call(cbind,simpleMainEffect2.)
    }

    posthoc = cbind(simpleMainEffect1,simpleMainEffect2)
  }
  stopCluster(cl)

  result = cbind(twowayMixedANOVA, posthoc)
  result = cbind(data.frame(f$`compound label`),result)
  colnames(result)[1] = "compound label"



  fwrite(data.table(result),"TwoWayMixedANOVA.csv")
  fwrite(data.table(result),"TwoWayMixedANOVA.txt",sep = "\t")


  return(result)


}
