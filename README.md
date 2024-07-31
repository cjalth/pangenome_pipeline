# Using the human pangenome to improve childhood cancer genome analysis

The draft human reference genome was published in 2000 and has been improving in quality ever since (now version 38) yet is still missing large swathes of DNA sequence. Furthermore, as researchers have sequenced thousands of individuals, and discovered millions of unique genetic variants, it has become apparent that the linear reference genome is no longer the best way to represent all this genetic variation. Enter the pangenome, a new approach to store the reference genome as a graph, with loops in the graph representing each unique genetic variant: each individual has a unique path through the graph. This promises to be both a more efficient way to store population-scale genetic variation, and a more accurate way to analyse genetic variation in an individual’s genome.

Here we seek to assess the feasibility of using the human pangenome to improve childhood cancer genome analysis. We propose to first develop an analysis pipeline using nextflow, specifically for cancer, where we wish to compare the sequence of a patient’s germline genome and their tumour genome. From this, you will then align short-read sequencing data from childhood cancer patients to the draft human pangenome graph (e.g. using vg or giraffe). We then wish to identify important tumour-specific genetic variants from this resulting graph. This will be to the best of our knowledge, the first time this approach has been undertaken for childhood cancer.

## Our Solution

We have created a genomic analysis pipeline using Nextflow to help researchers in their analysis of short-read data with the pangenome by efficiently automating the process of data alignment to the human reference pangenome. This means that instead of manually entering, converting and aligning data samples contained in .bam files to a pangenome graph, researchers are able to input those files into our more streamlined pipeline to automate a process which originally would’ve taken 10 times longer. It also not only reduces the difficulty of detecting structural variation in all genomic contexts but also unveils a new possibility of exploring the functional impact of previously inaccessible variants. 

## How to Use

In order to use and implement the genomic analysis pipeline, 

