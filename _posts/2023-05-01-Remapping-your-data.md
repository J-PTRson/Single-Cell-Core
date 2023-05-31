---
layout: post
title: Remapping your sequencing data to a different reference genome
author: jpeterson
tags: [Preprocessing, scKaryo-seq, scChIC-seq]
categories: Tutorial
---

With all the information available about genome sequencing one could easily be forgiven to know that within many genome references there are still genomic regions that have not been characterized in much detail. Sometimes it might be a good idea to use a different reference genome than your current one. In this blog we'll walk you through the steps of remapping your data following the pre-processing methods used at the [**Single Cell Core**](https://www.singlecellcore.eu/).

## Introduction

Although our current knowledge base about the intricacies of human genetics have been steadily increasing over the years since the initial release of the [**human reference genome**](https://www.nature.com/articles/35057062) in the early 2000's. Last year the research efforts of the Telomere-to-Telomere (T2T) consortium payed off with their publication of the [**complete sequence of a human genome**](https://www.science.org/doi/10.1126/science.abj6987). Here we will show our methods to remap your single cell sequencing data using the tools within the [**SingleCellMultiOmics**](https://github.com/BuysDB/SingleCellMultiOmics/tree/master) collection made by the Alexander van Oudenaarden Lab.

Curious to explore the utility of the SingleCellMultiomics collection? See our previous **blog** to get you set up!

## Prerequisites

-   Your sequencing fastq files.
-   [**SingleCellMultiOmics**](https://github.com/BuysDB/SingleCellMultiOmics/tree/master) package
-   The [**T2T-CHM13v2.0**](https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_009914755.4/) human genome reference sequences (FASTA) (GenBank assembly).
-   [**Burrows-Wheeler Aligner**](https://bio-bwa.sourceforge.net/)
-   [**Samtools**](http://www.htslib.org/)
-   Bash-terminal

## Preparation

Before we can start with mapping of the data, there are a number of preparations that have to be in place for everything to run smoothly. First start with making a labeled directory where all your human reference genome information will be stored.

``` bash
mkdir ./human_reference
```

Go to the directory in which the genome reference file was downloaded and move that to that directory human_reference folder. Unzip the reference file if necessary, and you'll recover the fasta file. The T2T-CHM13v2 reference genome will unpack as a fasta file with a .fna extension. The .fna extenstion specifies in its name that it refers to a **fasta nucleic acid** file. This prevents ambiguity when examining the file, but in our case the tools we will use will expect fasta files to be referenced with the "more general" .fa extension. By renaming the .fna fasta file to .fa this will not cause any problems later on.

``` bash
mv ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fna ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fa
```

Lets inspect part of the reference file:

``` bash
cat ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fa | head -n 5 
```

{% include aligner.html images="tutorials/Screenshot_T2T.png" %}

Here we can see that in the first line the chromosome names start with the GenBank nomenclature (CP068277.2). Personally, I prefer the NCBI style of chromosome referencing, and as such I will change this. One thing to keep in mind is that sometimes certain tools only work with a certain chromosome format.

``` bash
sed -i 's/CP068277.2/1/g;s/CP068276.2/2/g;s/CP068275.2/3/g;s/CP068274.2/4/g;s/CP068273.2/5/g;s/CP068272.2/6/g;s/CP068271.2/7/g;s/CP068270.2/8/g;s/CP068269.2/9/g;s/CP068268.2/10/g;s/CP068267.2/11/g;s/CP068266.2/12/g;s/CP068265.2/13/g;s/CP068264.2/14/g;s/CP068263.2/15/g;s/CP068262.2/16/g;s/CP068261.2/17/g;s/CP068260.2/18/g;s/CP068259.2/19/g;s/CP068258.2/20/g;s/CP068257.2/21/g;s/CP068256.2/22/g;s/CP068255.2/X/g;s/CP086569.2/Y/g;s/CP068254.1/MT/g' ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fa
```

To check that all chromosome names have been changed run:

``` bash
cat ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fa | grep "Homo sapiens"
```

{% include aligner.html images="tutorials/Screenshot_T2T_convert.png" %}

A list of chromosome aliases for T2T-CHM13v2 can be found [**here**](https://hgdownload.soe.ucsc.edu/hubs/GCA/009/914/755/GCA_009914755.4/GCA_009914755.4.chromAlias.txt)**.**

Next we will have to index the human genome reference using the Burrows-Wheeler Aligner (BWA). Due to the sheer size of the human genome, this process might take quite some time to complete.

``` bash
bwa index ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fa
```

We'll also further index the reference file using samtools faidx.

``` bash
samtools faidx ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fa
```

(Optionally) In the scenario that scKaryo-seq data will be mapped, a simulated mappability file is recommended.

``` bash
createMappabilityIndex.py ./GCA_009914755.4_T2T-CHM13v2.0_genomic.fa -maxlen 94 -digest_sequence CATG
```

**Continue using the snakemake...**
