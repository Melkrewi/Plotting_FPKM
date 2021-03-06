library(data.table)
library(gridExtra)
library(grid)
library(ggplot2)
library(lattice)
library(plyr) 
library(ggplot2) 
library(reshape2) 
library(tidyverse) 
library(ggpubr)
library("stringr") 
setwd("~/git/Plotting_FPKM/") #setting working directory 

#loading and maniuplating the data
RPKM <-fread("PLoS_data.txt", sep="auto",head=T) 
RPKM_60u <- RPKM %>% 
  dplyr::select(V1,starts_with("60"))
RPKM.df <- setNames(melt(RPKM_60u), c('rows', 'vars', 'values'))
test <- plyr::arrange(RPKM.df, rows)
test <- test %>%
  tidyr::separate(vars, c("NI","emb","slice","rest"),sep="_",remove = F,extra ="merge")

#plotting 
plotlist=list()
names_list=list("lab","pb","Dfd","Scr","Antp","Ubx","abd-A","Abd-B")
for (i in 1:length(names_list)){
  p <- ggplot(subset(test,rows ==names_list[i]), aes(x = slice, y = rows, fill = values)) + facet_grid(emb ~ ., scales='free_x', space="free_x") + geom_tile() + scale_fill_gradient(low = "#FFFFFF",high = "#012345")+ theme(plot.title = element_text(hjust = 0.5),axis.title.y=element_blank(),axis.ticks.y = element_blank(), axis.text.y = element_blank()) + ggtitle(paste(names_list[i]))
  plotlist[[i]]=p
}
# why not facets? I think if I use facets for all, then the filling will be relative to the highest expression gene, but I am not sure. 
# SarenT: that's not true, you can set separately see cheat sheet. Please use facets. Also since your project is sort of too small, can you make a nicer plot?
# Can you include "25u" as well? And use summarise for a separate plot?

main<-grid.arrange(grobs=plotlist,ncol=length(names_list))
ggsave("hox_genes.pdf",main,width=40,height=5)

