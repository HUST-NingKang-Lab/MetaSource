##
##**********************************************************##
##
## * Author        : pengshuo yang
## * Email         : yangps@hust.edu.cn
## * Create date   : 2020-12-08 15:57
## * Filename      : aligntotaxonomy.sh
## * Version       : 1.0.0
## * Description   : catch the tree information on Pfam database 
##                   and calculate the species distribution on 
##                   different taxonomical level
## * *******************************************************##


#!/bin/bash
#usage sh aligntotaxonomy.sh pfamlist taxonomiclevel
##the pfamlist is the list of Pfam families  the specie distribution
##would be calculated.

##the taxonomiclevel is the taxonomical level of the taxonomy database
##1:Kingdom; 2:Phylum; 3:Class; 4:Order;
##5:Family; 6:Genus; 7:Species 

##global variable

pfamlist=$1
level=$2

###step1 obtain the reference taxonomy database in pfam database 
wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam32.0/database_files/taxonomy.txt.gz
gzip -d taxonomy.txt.gz

##step2 download the taxonomical tree from Pfam database
##this step is implemented by download.py
python download.py  $pfamlist

##step3 obtain the detail taxonomical distribution for selected pfam

mkdir 'level'${level}
leveldir='level'${level}

while read NAME ;

do
   var=$(cat $NAME"_out")
   for i in $var
   do
    grep -m 1 $i ./taxonomy.txt|cut -d ";" -f $level  >> ./$leveldir/$NAME;
    done

done<${pfamlist}

##step4 combine the species distribution for  pfam familie in Pfamlist
cd 'level'${level}

while read line;
do

cat $line|grep -v '^$' |sort|uniq -c|awk  '{print "'$line'",$2,$1}'|sed  "s/ /\t/g">>speciesdistribution;

done<../${pfamlist} 
cd ..

##Finally,the species distribution could be obtained like this##
##Pfam1	species1	count##
##Pfam1	species2	count##
##Pfam2	speices1	count##
##Pfam2	species2	count##
