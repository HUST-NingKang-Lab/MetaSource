# MetaSource

This repository is the source code and intermediate results for the research "Decoding microbiome and protein family linkage to improve protein structure prediction".

This repository is constructed for the researchers to reproduce the results of the metagenome analysis and machine learning model construction in the research "Decoding microbiome and protein family linkage to improve protein structure prediction". Moreover, the intermediate results of protein 3D structure is avaliable at our [releases](https://github.com/HUST-NingKang-Lab/MetaSource/releases). Moreover,the protein 3D structure result including [168 benchmark dataset for C-I-TASSER](https://zhanglab.ccmb.med.umich.edu/C-I-TASSER/metasource/benchmark.zip),[2204 predicted 3D structure models](https://zhanglab.ccmb.med.umich.edu/C-I-TASSER/metasource/pfam.zip) and [1020(204*5) validation models for MetaSource](https://zhanglab.ccmb.med.umich.edu/C-I-TASSER/metasource/testset.zip)is also downloadable through zhanglab.

## Workflow for our research
<img src="image/Figure1.png">
(A) Sequences from different biomes were collected, and the biome-sequence associations are also organized. 
(B) Sequences from different biomes are aligned to Pfam families for homolog sequence supplementation, and new multiple sequence alignment (MSA) is constructed. 
(C) For Pfam families with C-score over -0.25, the marginal effect is evaluated for four biomes to quantify the effects of metagenome data from different biomes on Pfam families. 
(D) Pfam families with C-score over -0.25 were assigned to their respective source biomes, as the biome-Pfam association. 
(E) The multiclass random forest model construction using Pfam families with unsolved structures. 
(F) The validation of metasource using Pfam families whose structure solved.
## Summary

  - [Repository structure](#getting-started)
  - [Prerequisites](#Prerequisites)
  - [Usage](#Usage)
  - [Authors](#authors)
  - [License](#license)

## Repository structure

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on how to deploy the project on a live system.
```reStructuredText
.
├── code                                                              :main source code for the metagenome analysis and MetaSource model construction
│   ├── analysis of metagenome                                        :Metagenome analysis for collected samples
│   │   ├── Figure2(b).csv                                            :Top 10 Phyla distribution for 1,705 metagenome data
│   │   ├── Figure2_b_genera_abundance_source.R                       :R code to illustrate the relative abundance distribution of Top 10 Phyla for 1,705 metagenome data
│   │   ├── Figure2(d).csv                                            :Phylum with relative abundance over 0.01% for PCA analysis
│   │   └── Figure2_d_PCoA.R                                          :R code to calculate and illustrate the PCA analysis
│   ├── datapreparationforMetaSource                                  :to calculate the species distribution for the Pfam family
│   │   ├── aligntotaxonomy.sh                                        :shell script to calculate the species distribution for the Pfam family
│   │   ├── download.py                                               :python script to download the tree file of given Pfam list
│   │   └── list                                                      :example Pfam list to run the script
│   └── MetaSource                                                    :to construct the MetaSource prediction model 
│       ├── binary                                                    :binary prediction model to judge whether the source biome of queried Pfam family is one of four biome
│       │   ├── binary_classification.csv                             :input data for binary prediction model.
│       │   └── binary_randomforst.py                                 :python script for constructing the randomforest model in binary prediction model
│       └── multiple                                                  :multiple prediction model to track the source biome of queried Pfam family 
│           └── multiple_class_random_forest.ipynb                    :python script for constructing the randomforest model in multiple prediction model
├── img                                                               :image used in this repository
│   └── Figure1.png                                                   :workflow of our research
└── Phase2 Intermediate                                               :Intermediate results in this study
    ├── Figure2                                                       :Directory of intermediate results in the Figure 2 of manuscript
    │   ├── Figure2(a).xlsx                                           :Data files for plotting the Figure 2 a of manuscript
    │   ├── Figure2(b).csv                                            :Data files for plotting the Figure 2 b of manuscript
    │   ├── Figure 2(c)                                               :Data files for plotting the Figure 2 c of manuscript
    │   │   ├── fermi_count                                           :The phylum of Pfam families which could supplement the homologous sequence from fermentor biome 
    │   │   ├── gut_count                                             :The phylum of Pfam families which could supplement the homologous sequence from gut biome
    │   │   ├── lake_count                                            :The phylum of Pfam families which could supplement the homologous sequence from lake biome
    │   │   ├── soil_count                                            :The phylum of Pfam families which could supplement the homologous sequence from soil biome
    │   └── Figure2(d).csv                                            :Data files for plotting the Fig.2 d of manuscript
    ├── Figure3                                                       :Directory of intermediate results in the Fig.3 of manuscript
    │   ├── Figure 3 a.xlsx                                           :Data files for plotting the Figure 3 a of manuscript
    │   ├── Figure 3 b.csv                                            :Data files for plotting the Figure 3 b of manuscript
    │   ├── Figure 3 c.pptx                                           :Data files for plotting the Figure 3 c of manuscript
    │   └── Figure3 d-f                                               :Data files for plotting the Figure 3 d-f of manuscript
    │       ├── Agut_go.txt                                           :Go annotation for the Pfam families which could supplement the homologous sequence from gut biome
    │       ├── Blake_go.txt                                          :Go annotation for the Pfam families which could supplement the homologous sequence from lake biome
    │       ├── Csoil_go.txt                                          :Go annotation for the Pfam families which could supplement the homologous sequence from soil biome
    │       └── Dferm_go.txt                                          :Go annotation for the Pfam families which could supplement the homologous sequence from fermentor biome
    ├── Figure4                                                       :Directory of intermediate results in the Figure 4 of manuscript
    │   ├── Figure 4 a.xlsx                                           :Data files for plotting the Figure 4 a of manuscript
    │   ├── Figure 4 b.xlsx                                           :Data files for plotting the Figure 4 b of manuscript
    │   ├── Figure 4 c.xlsx                                           :Data files for plotting the Figure 4 c of manuscript
    │   └── Figure 4 d.xlsx                                           :Data files for plotting the Figure 4 d of manuscript
    ├── Figure S1                                                     :Directory of intermediate results in the Supplementary Figure 1 of manuscript
    │   └── 3d-phase2_observed_OTU.csv                                :The observerved OTU table of these samples used in the Supplementary Figure 1 of manuscript
    ├── Figure S4                                                     :Directory of intermediate results in the Supplementary Figure 4 of manuscript
    │   └── Figure S4.xlsx                                            :The sampling country of the human gut microbiome used in the Supplementary Figure 4 of manuscript
    ├── Figure S5                                                     :Directory of intermediate results in the Supplementary Figure 5 of manuscript
    │   └── Figure S5.xlsx                                            :Data files for plotting the Supplementary Figure 5 of manuscript
    ├── Figure S6                                                     :Directory of intermediate results in the Supplementary Figure 6 of manuscript
    │   └── Figure S6.xlsx                                            :Data files for plotting the Supplementary Figure 6 of manuscript
    ├── Metasource                                                    :Directory of Metasource results
    │   ├── binnary_classification                                    :Directory of binnary_classification results, including the nagative dataset and positive dataset
    │   │   ├── nagative dataset.csv                                  :species distribution of the 8,599 Pfam familes with unsolved structure that could not be classified into one of the four source biome
    │   │   └── positive dataset.csv                                  :species distribution of the 964 Pfam familes with unsolved structure that could be classified into one of the four source biome
    │   └── multiple_classificaiton                                   :Directory of multiple_classificaiton results, including the traning dataset and validation dataset
    │       ├── traningset.csv                                        :species distribution of the 964 Pfam familes with unsolved structure that could be classified into one of the four source biome
    │       └── validationdataset.csv                                 :species distribution of the 9,229 Pfam familes with solved structure that could be classified into one of the four source biome
    └── readme.txt                                                    :readmefile for the all intermediate results in this study
```

### Prerequisites

All the R script were performed under version 3.6.1
All the Python script were performed under version 3.7.1
The reqirement of package of each script is listed in the top of each script

### Usage

1.For script in the folder "analysis of metagenome",the script could be performed directly in R and the input data has been supplied in the same folder.
2.For the script in datapreparationforMetaSource:
usage: sh aligntotaxonomy.sh list taxonomiclevel

the list is the list of queried Pfam families for which the specie distribution would be calculated.

the taxonomiclevel is the taxonomical level of the taxonomy database
1:Kingdom; 2:Phylum; 3:Class; 4:Order;
5:Family; 6:Genus; 7:Species 

After the calculation, the species could be obtained, like:

Pfam1	species1	count
Pfam1	species2	count
Pfam2	speices1	count
Pfam2	species2	count

## Authors

Pengshuo Yang |yangps@hust.deu.cn|Ph.D. Candidate, School of Life Science and Technology, Huazhong University of Science & Technology
Wei Zheng|jlspzw139@sina.com|Post-Doctoral Fellow, Department of Computational Medicine and Bioinformatics, University of Michigan
Kang Ning|ningkang@hust.edu.cn|Professor, School of Life Science and Technology, Huazhong University of Science & Technology
Yang Zhang|zhngu@mich.edu|Professor,Department of Computational Medicine and Bioinformatics, University of Michigan
## License

This project is licensed under the [GNU General Public License v3.0](LICENSE.md)
Creative Commons License - see the [LICENSE.md](LICENSE.md) file for
details

