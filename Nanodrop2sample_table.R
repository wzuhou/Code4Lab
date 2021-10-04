#######################
#######################
### Author: Zhou Wu
### Time: 2021/09/29
###Usage: [input1]    Nanodrop report file (can be excel *.xlsx), preferable with a NOTE info column.
###       [input2]    Sample table for information(at least include Columns such as ID to use as the key) .
###       [output]    Seperate tables summarized in the way you required, such as group by Species, Stage, and Sex showen in this example.
#######################
#######################

library(plyr)
library(readxl)
library(dplyr)
#Working directary
setwd('E://ROSLIN/Sampleing/20210907_test_nanodrop/Nanodrop_RNA_quality_202109')

#Sample info input2 table summarized in the way you required, such as group by Species, Stage, and Sex showen in this example
SAmple <- read_excel("SampleTable.xlsx")
#head(SAmple)
#Nanodrop input1
excel_sheets("HEART_N66_WCS_20210923NANODROP.txt.xlsx")
nanodrop <- read_excel("HEART_N66_WCS_20210923NANODROP.txt.xlsx",sheet = "n=66")
#names(nanodrop)
#Changing the header of nanodrop tables
df<- nanodrop[,c("Sample ID","ng/ul","260/280","260/230","ID","45ul","Homog #","NOTE")]
names(df) <- c("Sample ID","Con","260_280","260_230","ID","Volume","HomogID","NOTE")
df$TOTAL_RNA <- df$Volume*df$Con 
head(df)

# Join the two inputs by ID column, required: both files have a column named "ID", and should be the key used to match two files
test<-join(SAmple,df,by="ID",type="left",match="all")
#head(test)

#Sample table info organizing
SAm2 <- test%>%
  group_by(Species) %>%
  group_by(Stage) %>%
  group_by(Sex) %>%
  select(Species,Stage,Sex,ID,"Con",'260_280','260_230','NOTE',"TOTAL_RNA")%>%
  mutate(info=paste(Species,Stage,Sex,sep="_"))
#How do you want to output the sample table, example showed here by SAm2$info
list_info <- unique(SAm2$info)
#head(SAm2)
##########
##OUTPUT##
##########
for (i in list_info){
  #print(i)
  #i=list_info[[1]]
  a <- SAm2%>%
    filter(info==i)%>%
    select(ID,Con,'260_280','260_230','NOTE',"TOTAL_RNA")
  a <- as.data.frame(a)
a <- a[,c('ID','Con','260_280','260_230','NOTE',"TOTAL_RNA")]
#a$Total_RNA=NA
a$Alternative_sample=NA
a$Re_extraction_possible=NA
a
a2 <- data.frame(t(a[-1]))
colnames(a2) <- a[, 1]
a2
cat(i,file=paste0(i,".csv"))
  #Output by info iteratively
write.table(a2,file=paste0(i,".csv"),sep=',',quote=F,append=TRUE,col.names = NA)
}

#tidyr::gather(SAm2,key="Bird1",-ID)
