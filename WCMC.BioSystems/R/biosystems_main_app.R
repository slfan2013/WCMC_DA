library(pacman)
pacman::p_load(rcdk, RCy3, piano,RJSONIO,RCurl,stringr, ggplot2, httr,grid, png,ReporteRs,svglite, doSNOW, foreach,ggrepel,gridExtra,ape,plotrix)

allpath <- read.delim("D:/NCBI_BioSystems/biosystems_pccompound", header = F, stringsAsFactors = F)
## Human pathways, Wikipathways and the Gene ontology pathways were downloaded from NCBI Biosystems database. That, we are going to filter.
human_path <- read.csv("D:/NCBI_BioSystems/90909597810033510.csv", header = T, stringsAsFactors = F)

human_data <- allpath[which(allpath$V1%in%human_path$BSID==TRUE),]
write.table(human_data,"D:/NCBI_BioSystems/human_pathways.txt", sep="\t", quote = F, col.names = F, row.names = F)
human_data <- read.delim("D:/NCBI_BioSystems/human_pathways.txt", header = F, stringsAsFactors = F)

stat_res <- read.delim("C:/Users/barupal-pc/Google Drive/WCMC_Projects/ColumbiaUniversity/stat_results.txt", header = T, stringsAsFactors = F)
stat_res <- stat_res[order(stat_res$P_value),]

exp_path <- human_data[which(human_data$V2%in%stat_res$CID==T),]


stat_res1 <- stat_res[duplicated(names(gstatsdirection1))==FALSE,]
glaydf1 <- exp_path[,c(2,1)]
gstatsdirection1 <- rep(1,nrow(stat_res1))
gstatsdirection1[which(stat_res1$P_value<0.10)]   <- -1 ## on a pvalue of this threshold, how many were affected or not.
names(gstatsdirection1) <- stat_res1$CID
gsdf <- loadGSC(glaydf1)
gsares <- runGSA(geneLevelStats=gstatsdirection1,geneSetStat = 'fgsea', gsc=gsdf, nPerm=1000)
gsa_res <- GSAsummaryTable(gsares)
gsa_res$threshold <- cutoff

excdf <- gsa_res



cidvec <- stat_res$CID
getElinkJSON <- function(id) {
  elinkurl =  paste(c('https://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pccompound&db=biosystems&id=',id, '&retmode=json'),collapse="")
  fromJSON(getURL(elinkurl, .opts = list(ssl.verifypeer = FALSE)))
}

biosyslist <- sapply(cidvec, getElinkJSON)
