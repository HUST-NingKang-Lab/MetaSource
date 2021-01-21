#!/usr/bin/python
# -*- coding: utf-8 -*-
import urllib
import socket
import sys
import re
###1.download the tree file
socket.setdefaulttimeout(1000.0)
input = sys.argv[1]
file_in = open(input)
for line in file_in.readlines():
    line2 = line.rstrip("\n")
    print "downloading the tree file for %s"%line2
    response = urllib.urlopen("http://pfam.xfam.org/family/browse?browse=a")
    response = urllib.urlopen("http://pfam.xfam.org/speciestree/text?loadTree=1&acc=%s"%line2)
    file_out = open("%s_tree"%line2,"w")
    file_out.write("%s"%response.read())

##2.calculate the genus distribution for tree
for name1 in file_in.readlines():
    name = name1.strip("\n")
    tree_in = open("%s_tree"%name)
    tree_out = open("%s_out_genera"%name,"w")
    for line in tree_in.readlines():
        line2 = line.rstrip("\t")
        line2 = line2.rstrip("\n")
        line3 = line2.split("+--")
        if len(line3) > 1:
            line4 = line3[-1].split()
            if len(line4)==3:
                line4.pop()
                line4 = " ".join(line4)
                tree_out.write("%s\n"%line4)
    tree_out.close()
    tree_in.close()
##3.extract the genus distribution for the pfam tree
file_name = open(input)
for name1 in file_name:
	name = name1.strip("\n")
	file_in = open("%s_tree"%name)
	file_out = open("%s_out"%name,"w")
	for line in file_in.readlines():
		line2 = line.rstrip("\t")
		line2 = line2.rstrip("\n")
		line3 = line2.split("+--")
		if len(line3) > 1:
			line4 = line3[-1].split()
			if len(line4)==3:
				line4.pop()
				line4 = " ".join(line4)
				file_out.write("%s\n"%line4)
 	file_out.close()
 	file_in.close()

