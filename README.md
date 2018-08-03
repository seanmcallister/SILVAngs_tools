# SILVAngs tools

A collection of tools for converting SILVAngs output for use in Qiime and for recovering true abundance when collapsing a repset prior to SILVAngs submissions. When you call the program use ```-h``` to see the help information.

Tools:

1. ```SILVAngs_Qiime_convert_v3.pl```
2. ```cdhit_abundance_recovery.pl```
3. ```cdhit_abundance_recovery_100perc.pl```

Tool 1 converts the SILVAngs classification pipeline export (```x---ssu---otus.csv```) to a format for import into Qiime as a taxonomic summary.

Tools 2 & 3. Generally, when I run SILVAngs I like to first collapse redundant reads to minimize my footprint. I do this using cd-hit, usually clustering by 100% identity. The resulting .clstr file can be used after running SILVAngs to get back the true abundance of each taxonomically classified sequence. These help with that.
