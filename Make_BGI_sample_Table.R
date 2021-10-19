### BGI sample table

{library(plyr)
library(xlsx)
library(readxl)
library(dplyr)}
setwd("E:/ROSLIN/Sampleing/BGI/")
#setwd('E:/ROSLIN/Sampleing/20210907_test_nanodrop/Nanodrop_RNA_quality_202109')

### 1. read in info and merg
### sample info

SAmple <- read_excel("E:/ROSLIN/Sampleing/20210907_test_nanodrop/Nanodrop_RNA_quality_202109/SampleTable_info.xlsx")
head(SAmple)

### directory to nanodrop input
excel_wd="E:/ROSLIN/Sampleing/20210907_test_nanodrop/Nanodrop_RNA_quality_202109/"

### nanodrop input
Tissue="ADREN"
nfile="ADRENAL_N67_WCS_20210920.xlsx"
# "ZHOU-GONAD-N61-20210908-REPORT.xlsx"
# "FAT_N66_WCS_20210922NANODROP.xlsx" sheet2
# "ADRENAL_N67_WCS_20210920.xlsx" Sheet2
# "HEART_N66_WCS_20210923NANODROP.txt.xlsx"


### select the worksheet

excel_sheets(paste0(excel_wd,nfile))
nanodrop <- read_excel(paste0(excel_wd,nfile),sheet = "Sheet2")
names(nanodrop)
df<- nanodrop[,c("Sample ID","ng/ul","260/280","260/230","ID","45ul","Homog #","NOTE")]
names(df) <- c("Sample ID","Con","260_280","260_230","ID","Volume","HomogID","NOTE")

df$TOTAL_RNA <- df$Volume*df$Con #Calculate the total RNA
head(df)


### merge info from nanodrop and sample info

test<-join(SAmple,df,by="ID",type="left",match="all")
head(test)

SAm2 <- test%>%
  group_by(Species) %>%
  group_by(Stage) %>%
  group_by(Sex) %>%
  select(Species,Stage,Sex,ID,HomogID,"Con",'260_280','260_230','NOTE',"TOTAL_RNA","Volume")%>%
  mutate(info=paste(Species,Stage,Sex,sep="_"))%>%
  mutate('Sample Name'=paste(Tissue,HomogID,ID,sep='_'))
SAm2 <- as.data.frame(SAm2)

sum(!is.na(SAm2$TOTAL_RNA) & SAm2$TOTAL_RNA>='675')
SAm2[!is.na(SAm2$TOTAL_RNA) & SAm2$TOTAL_RNA=='675',]
{SAm2[!is.na(SAm2$TOTAL_RNA) & SAm2$TOTAL_RNA=='675',]$Volume =45
SAm2[!is.na(SAm2$TOTAL_RNA) & SAm2$TOTAL_RNA=='675',]$Con =15}
head(SAm2)
SAm2$"28s:18s"<-NA


### 2. unselect RE-DO ONES save to my meta data

redo <- read_excel("E:/课件/ROSLIN/Sampleing/20210907_test_nanodrop/Nanodrop_RNA_quality_202109/20211014_redo_sample_list_WCS.xlsx")
#SAm2 <- SAm2
SAm2[SAm2$`Sample Name` %in% redo$`Sample ID`,]$TOTAL_RNA=NA
summary(SAm2$TOTAL_RNA)

write.xlsx(SAm2,file=paste0(Tissue,"_myfile_meta.xlsx"),row.names = F)

### write output
# of <- SAm2[,c("Sample Name","Species","Con","Volume","TOTAL_RNA",'260_280','260_230',"28s:18s",'NOTE')]
# names(of) <- c("Sample Name","Species", "Quantity of Tubes	Concentration (ng/ul)","Volume (ul)",	"Total Quantity (μg)",	"OD260/280",	"OD260/230",	"28s:18s",	"Comments")
# write.table(of,file=paste0(Tissue,"_myfile_BGI.csv"),sep=',',quote=F,append=F,row.names = F)


###------------------------------------
### !!! Manually change V, Con, Total RNA if needed, before outputing it to Final BGI!!!
###------------------------------------
### final output for BGI

SAm3 <- read_excel(paste0(Tissue,"_myfile_meta.xlsx"))
SAm3 <- as.data.frame(SAm3)
SAm3[SAm3$`Sample Name` %in% redo$`Sample ID`,]$Con=NA
SAm3[SAm3$`Sample Name` %in% redo$`Sample ID`,]$'260_280'=NA
SAm3[SAm3$`Sample Name` %in% redo$`Sample ID`,]$'260_230'=NA
SAm3$Con <- round(as.numeric(SAm3$Con),2)
head(SAm3)
of2 <- SAm3[,c("Sample Name","Species","Con","Volume","TOTAL_RNA",'260_280','260_230',"28s:18s",'NOTE')]
names(of2) <- c("Sample Name","Species", "Quantity of Tubes	Concentration (ng/ul)","Volume (ul)",	"Total Quantity (ug)",	"OD260/280",	"OD260/230",	"28s:18s",	"Comments")

write.table(of2,file=paste0(Tissue,"_Fianl_BGI.csv"),sep=',',quote=F,append=F,row.names = F)

