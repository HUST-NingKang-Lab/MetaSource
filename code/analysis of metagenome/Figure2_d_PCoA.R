#Uncomment next two lines if R packages are already installed
#install.packages("cluster")
#install.packages("clusterSim")
#library(cluster)
#library(clusterSim)
library(vegan)
library(ggplot2)
library(plyr)
library(ade4)
#Download the example data and set the working directory
#setwd('<path_to_working_directory>')
setwd("E:\\QQ个人文件夹/422384334/FileRecv/")
data=(read.table("testforpca_level2.txt", header=T, row.names=1, sep="\t"))
dataSpe<-data[,3:48]
dataEnv<-data[,1:2]
dataEnv$ID <- rownames(dataEnv)
distance <- vegdist(dataSpe, method = 'jaccard')
pcoa <- cmdscale(distance, k = (nrow(dataSpe) - 1), eig = T)
pcoa_eig <- {pcoa$eig}[1:2]
#提取样本点坐标（前两轴）
dataplotG <- data.frame({pcoa$point})[1:2]
dataplotG$ID <- rownames(dataplotG)
names(dataplotG)[1:2] <- c('PCoA1', 'PCoA2')
#为样本点坐标添加分组信息
dataplotG <- merge(dataplotG, dataEnv, by = 'ID', all.x = T)
pcoa_plot<-ggplot(dataplotG, aes(PCoA1, PCoA2, col = dataplotG$Type)) +
  theme(panel.grid =element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent'),legend.key = element_rect(fill = 'transparent'))+ #去掉背景框
  geom_vline(xintercept = 0, color = 'black', size = 0.4) + 
  geom_hline(yintercept = 0, color = 'black', size = 0.4) +
  stat_ellipse(level = 0.8,lwd=0,aes(x = PCoA1, y = PCoA2, fill = Type), geom = "polygon",alpha = 1/4,show.legend = F)+ 
  stat_ellipse(level = 0.9,aes(color=Type),lwd=1,linetype=2)+ #绘制90%置信圈
  geom_point(aes(color = Type), size = 5, alpha = 0.7) + #可在这里修改点的透明度、大小
  #scale_shape_manual(values = c(17:22)) + #可在这里修改点的形状，特征有几个，values的值，对应的也要增加。#shape order Soil,Rhizospher,Soil,Rhizospher,Unknown,Unknown
  scale_color_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE","#FFC484","#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+
  scale_fill_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+#, "IndianRed1","green","blue","yellow")) + #可在这里修改区块的颜色
  guides(fill = guide_legend(order = 1), shape = guide_legend(order = 2), color = guide_legend(order = 3)) +#设置图例展示顺序
  theme(axis.title.y =element_text(vjust = 0.5))+
  labs(x = paste("PCoA1 (", format(100*pcoa_eig[1]/sum(abs(pcoa$eig)), digits = 4), "%)",sep = "",vjust=0.5,hjust=0.5,angle=0.5),y = paste("PCoA2 (", format(100*pcoa_eig[2]/sum(abs(pcoa$eig)), digits = 4), "%)",sep = ""))
pcoa_plot

library(ggpubr)
#color order:Soil,Soil，Rhizospher,Rhizospher,Unknown,Unknown
col_MT<-c("#A4ABBF","#347373")
my_compar<-list(c("Rhizospher","Soil"))#,c("Soil"),c("Rhizospher"))#,c("Rhizospher","Soil"),c("Soil"),c("Rhizospher"))#S:TN\TP\WT
BoxPCoA1<-ggplot(dataplotG,aes(x=Biome,y=PCoA1))+
  geom_boxplot(aes(x=factor(Biome),y=PCoA1,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  scale_x_discrete(limits=c("Rhizospher","Soil"))+
  theme(legend.position = "none")+coord_flip()
BoxPCoA1
BoxPCoA2<-ggplot(dataplotG,aes(x=Type,y=PCoA2))+
  geom_boxplot(aes(x=factor(Type),y=PCoA2,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  scale_x_discrete(limits=c("Rhizospher","Soil"))+
  theme(legend.position = "none")
BoxPCoA2

dataTP <- data[which(data$Growth=="Therophyte"),]
######Rzos
dataSpe<-dataTP[,7:35]
dataEnv<-dataTP[,1:6]
dataEnv$ID <- rownames(dataEnv)
distance <- vegdist(dataSpe, method = 'jaccard')
pcoaTP <- cmdscale(distance, k = (nrow(dataSpe) - 1), eig = T)
pcoaTP_eig <- {pcoa$eig}[1:2]
#提取样本点坐标（前两轴）
dataTP <- data.frame({pcoaTP$point})[1:2]
dataTP$ID <- rownames(dataTP)
names(dataTP)[1:2] <- c('PCoA1', 'PCoA2')
#为样本点坐标添加分组信息
dataTP <- merge(dataTP, dataEnv, by = 'ID', all.x = T)
pcoa_plot_TP<-ggplot(dataTP, aes(PCoA1, PCoA2, col = Type)) +
  theme(panel.grid =element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent'),legend.key = element_rect(fill = 'transparent'))+ #去掉背景框
  geom_vline(xintercept = 0, color = 'black', size = 0.4) + 
  geom_hline(yintercept = 0, color = 'black', size = 0.4) +
  stat_ellipse(level = 0.8,lwd=0,aes(x = PCoA1, y = PCoA2, fill = Type), geom = "polygon",alpha = 1/4,show.legend = F)+ 
  stat_ellipse(level = 0.9,aes(color=Type),lwd=1,linetype=2)+ #绘制90%置信圈
  geom_point(aes(color = Type), size = 5, alpha = 0.7) + #可在这里修改点的透明度、大小
  #scale_shape_manual(values = c(17:22)) + #可在这里修改点的形状，特征有几个，values的值，对应的也要增加。#shape order Soil,Rhizospher,Soil,Rhizospher,Unknown,Unknown
  scale_color_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE","#FFC484","#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+
  scale_fill_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+#, "IndianRed1","green","blue","yellow")) + #可在这里修改区块的颜色
  guides(fill = guide_legend(order = 1), shape = guide_legend(order = 2), color = guide_legend(order = 3)) +#设置图例展示顺序
  theme(legend.position = "none",axis.title.y =element_text(angle = 79.9,vjust = 0.5))+
  labs(x = paste("PCoA1 (", format(100*pcoaTP_eig[1]/sum(abs(pcoaTP$eig)), digits = 4), "%)",sep = "",vjust=0.5,hjust=0.5,angle=0.5),y = paste("PCoA2 (", format(100*pcoaTP_eig[2]/sum(abs(pcoaTP$eig)), digits = 4), "%)",sep = ""))
pcoa_plot_TP

library(ggpubr)
#color order:Soil,Soil，Rhizospher,Rhizospher,Unknown,Unknown
col_MT<-c("#A4ABBF","#347373")
my_compar<-list(c("Rhizospher","Soil"))#M:TN\TP\WT #c("Soil","Rhizospher"),c("Soil"),c("Rhizospher"))#S:TN\TP\WT
BoxTPPCoA1<-ggplot(dataTP,aes(x=Type,y=PCoA1))+
  geom_boxplot(aes(x=factor(Type),y=PCoA1,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  scale_x_discrete(limits=c("Soil","Rhizospher"))+
  theme(legend.position = "none")+coord_flip()
BoxTPPCoA1

BoxTPPCoA2<-ggplot(dataTP,aes(x=Type,y=PCoA2))+
  geom_boxplot(aes(x=factor(Type),y=PCoA2,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  scale_x_discrete(limits=c("Soil","Rhizospher"))+
  theme(legend.position = "none")
BoxTPPCoA2


######Triennia
dataTN <- data[which(data$Growth=="Triennia"),]
dataSpeS<-dataTN[,7:35]
dataEnvS<-dataTN[,1:6]
dataEnvS$ID <- rownames(dataEnvS)
distance <- vegdist(dataSpeS, method = 'jaccard')
pcoaTN <- cmdscale(distance, k = (nrow(dataSpeS) - 1), eig = T)
pcoaTN_eig <- {pcoaTN$eig}[1:2]
#提取样本点坐标（前两轴）
dataplotTN <- data.frame({pcoaTN$point})[1:2]
dataplotTN$ID <- rownames(dataplotTN)
names(dataplotTN)[1:2] <- c('PCoA1', 'PCoA2')
#为样本点坐标添加分组信息
dataplotTN <- merge(dataplotTN, dataEnvS, by = 'ID', all.x = T)
pcoa_plot_TN <- ggplot(dataplotTN, aes(PCoA1, PCoA2, col = Type)) +
  theme(panel.grid =element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent'),legend.key = element_rect(fill = 'transparent'))+ #去掉背景框
  geom_vline(xintercept = 0, color = 'black', size = 0.4) + 
  geom_hline(yintercept = 0, color = 'black', size = 0.4) +
  stat_ellipse(level = 0.8,lwd=0,aes(x = PCoA1, y = PCoA2, fill = Type), geom = "polygon",alpha = 1/4,show.legend = F)+ 
  stat_ellipse(level = 0.9,aes(color=Type),lwd=1,linetype=2)+ #绘制90%置信圈
  geom_point(aes(color = Type), size = 5, alpha = 0.5) + #可在这里修改点的透明度、大小
  scale_shape_manual(values = c(17:19)) + #可在这里修改点的形状，特征有几个，values的值，对应的也要增加。#shape order Soil,Rhizospher,Soil,Rhizospher,Unknown,Unknown
  scale_color_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE","#FFC484","#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+
  scale_fill_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+#, "IndianRed1","green","blue","yellow")) + #可在这里修改区块的颜色
  guides(fill = guide_legend(order = 1), shape = guide_legend(order = 2), color = guide_legend(order = 3)) +#设置图例展示顺序
  theme(legend.position = "none",axis.title.y =element_text(angle = 79.9,vjust = 0.5) )+
  labs(x = paste("PCoA1 (", format(100*pcoaTN_eig[1]/sum(abs(pcoaTN$eig)), digits = 4), "%)",sep = "",vjust=0.5,hjust=0.5,angle=0.5),y = paste("PCoA2 (", format(100*pcoaTN_eig[2]/sum(abs(pcoaTN$eig)), digits = 4), "%)",sep = "")) #+
pcoa_plot_TN

col_MT<-c("#A4ABBF","#347373")
my_compar<-list(c("Rhizospher","Soil"))#M:TN\TP\WT #c("Soil","Rhizospher"),c("Soil"),c("Rhizospher"))#S:TN\TP\WT
BoxTNPCoA1<-ggplot(dataplotTN,aes(x=Type,y=PCoA1))+
  geom_boxplot(aes(x=factor(Type),y=PCoA1,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  #scale_x_discrete(limits=c("Soil","Soil","Rhizospher","Rhizospher"))+
  theme(legend.position = "none")+coord_flip()
BoxTNPCoA1

BoxTNPCoA2<-ggplot(dataplotTN,aes(x=Type,y=PCoA2))+
  geom_boxplot(aes(x=factor(Type),y=PCoA2,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  #scale_x_discrete(limits=c("Soil","Soil","Rhizospher","Rhizospher"))+
  theme(legend.position = "none")
BoxTNPCoA2

######Wild type
dataWT <- data[which(data$Growth=="Unknown"),]
dataSpeS<-dataWT[,7:35]
dataEnvS<-dataWT[,1:6]
dataEnvS$ID <- rownames(dataEnvS)
distance <- vegdist(dataSpeS, method = 'jaccard')
pcoaWT <- cmdscale(distance, k = (nrow(dataSpeS) - 1), eig = T)
pcoaWT_eig <- {pcoaWT$eig}[1:2]
#提取样本点坐标（前两轴）
dataplotWT <- data.frame({pcoaWT$point})[1:2]
dataplotWT$ID <- rownames(dataplotWT)
names(dataplotWT)[1:2] <- c('PCoA1', 'PCoA2')
#为样本点坐标添加分组信息
dataplotWT <- merge(dataplotWT, dataEnvS, by = 'ID', all.x = T)
pcoa_plot_WT <- ggplot(dataplotWT, aes(PCoA1, PCoA2, Type = Type)) +
  theme(panel.grid =element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent'),legend.key = element_rect(fill = 'transparent'))+ #去掉背景框
  geom_vline(xintercept = 0, color = 'black', size = 0.4) + 
  geom_hline(yintercept = 0, color = 'black', size = 0.4) +
  stat_ellipse(level = 0.8,lwd=0,aes(x = PCoA1, y = PCoA2, fill = Type), geom = "polygon",alpha = 1/4,show.legend = F)+ 
  stat_ellipse(level = 0.9,aes(color=Type),lwd=1,linetype=2)+ #绘制90%置信圈
  geom_point(aes(color = Type), size = 5, alpha = 0.5) + #可在这里修改点的透明度、大小
  scale_shape_manual(values = c(17:19)) + #可在这里修改点的形状，特征有几个，values的值，对应的也要增加。#shape order Soil,Rhizospher,Soil,Rhizospher,Unknown,Unknown
  scale_color_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE","#FFC484","#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+
  scale_fill_manual(values = c("#A4ABBF","#347373","#67BFAD","#CDD452","#67B8DE"))+#, "IndianRed1","green","blue","yellow")) + #可在这里修改区块的颜色
  guides(fill = guide_legend(order = 1), shape = guide_legend(order = 2), color = guide_legend(order = 3)) +#设置图例展示顺序
  theme(legend.position = "none",axis.title.y =element_text(angle = 79.9,vjust = 0.5) )+
  labs(x = paste("PCoA1 (", format(100*pcoaWT_eig[1]/sum(abs(pcoaWT$eig)), digits = 4), "%)",sep = "",vjust=0.5,hjust=0.5,angle=0.5),y = paste("PCoA2 (", format(100*pcoaWT_eig[2]/sum(abs(pcoaWT$eig)), digits = 4), "%)",sep = "")) #+
pcoa_plot_WT

col_MT<-c("#A4ABBF","#347373")
my_compar<-list(c("Rhizospher","Soil"))#M:TN\TP\WT #c("Soil","Rhizospher"),c("Soil"),c("Rhizospher"))#S:TN\TP\WT
BoxWTPCoA1<-ggplot(dataplotWT,aes(x=Type,y=PCoA1))+
  geom_boxplot(aes(x=factor(Type),y=PCoA1,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  #scale_x_discrete(limits=c("Soil","Soil","Rhizospher","Rhizospher"))+
  theme(legend.position = "none")+coord_flip()
BoxWTPCoA1

BoxWTPCoA2<-ggplot(dataplotWT,aes(x=Type,y=PCoA2))+
  geom_boxplot(aes(x=factor(Type),y=PCoA2,fill=Type,alpha=0.6))+
  geom_point(aes(colour=Type),alpha=0.6,position="jitter")+#
  scale_colour_manual(values=(col_MT))+scale_fill_manual(values=col_MT)+
  stat_compare_means(comparisons = my_compar,method = "wilcox.test",label = "p.format",label.x = 3, paired = FALSE)+#used Wilcox.test for test
  theme_set(theme_bw()+theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()))+#ylim(-0.3,0.5)+
  #scale_x_discrete(limits=c("Soil","Soil","Rhizospher","Rhizospher"))+
  theme(legend.position = "none")
BoxWTPCoA2


library(grid)
grid.newpage()
l1 <- grid.layout(20,5)
vpmain<-viewport(layout =l1 ,name = "main")
pushViewport(vpmain)
print(pcoa_plot,vp = viewport(layout.pos.row = 1:4,layout.pos.col = 1:4))
print(BoxPCoA2,vp = viewport(layout.pos.row =1:4,layout.pos.col = 5))
print(BoxPCoA1,vp = viewport(layout.pos.row =5,layout.pos.col = 1:4))

print(pcoa_plot_TP,vp = viewport(layout.pos.row = 6:9,layout.pos.col = 1:4))
print(BoxTPPCoA2,vp = viewport(layout.pos.row =6:9,layout.pos.col = 5))
print(BoxTPPCoA1,vp = viewport(layout.pos.row =10,layout.pos.col = 1:4))

print(pcoa_plot_TN,vp = viewport(layout.pos.row = 11:14,layout.pos.col = 1:4))
print(BoxTNPCoA2,vp = viewport(layout.pos.row =11:14,layout.pos.col = 5))
print(BoxTNPCoA1,vp = viewport(layout.pos.row =15,layout.pos.col = 1:4))

print(pcoa_plot_WT,vp = viewport(layout.pos.row =15:19 ,layout.pos.col = 1:4))
print(BoxWTPCoA2,vp = viewport(layout.pos.row =15:19,layout.pos.col = 5))
print(BoxWTPCoA1,vp = viewport(layout.pos.row =20,layout.pos.col = 1:4))



