# DESN2000 - Using the human pangenome to improve childhood cancer genome analysis

The draft human reference genome was published in 2000 and has been improving in quality ever since (now version 38) yet is still missing large swathes of DNA sequence. Furthermore, as researchers have sequenced thousands of individuals, and discovered millions of unique genetic variants, it has become apparent that the linear reference genome is no longer the best way to represent all this genetic variation. Enter the pangenome, a new approach to store the reference genome as a graph, with loops in the graph representing each unique genetic variant: each individual has a unique path through the graph. This promises to be both a more efficient way to store population-scale genetic variation, and a more accurate way to analyse genetic variation in an individual’s genome.

Here we seek to assess the feasibility of using the human pangenome to improve childhood cancer genome analysis. We propose to first develop an analysis pipeline using nextflow, specifically for cancer, where we wish to compare the sequence of a patient’s germline genome and their tumour genome. From this, you will then align short-read sequencing data from childhood cancer patients to the draft human pangenome graph (e.g. using vg or giraffe). We then wish to identify important tumour-specific genetic variants from this resulting graph. This will be to the best of our knowledge, the first time this approach has been undertaken for childhood cancer.

## Our Solution

We have created this pipeline which ...
