# Using the human pangenome to improve childhood cancer genome analysis
The draft human reference genome was published in 2000 and has been improving in quality ever since (now version 38) yet is still missing large swathes of DNA sequence. Furthermore, as researchers have sequenced thousands of individuals, and discovered millions of unique genetic variants, it has become apparent that the linear reference genome is no longer the best way to represent all this genetic variation. Enter the pangenome, a new approach to store the reference genome as a graph, with loops in the graph representing each unique genetic variant: each individual has a unique path through the graph. This promises to be both a more efficient way to store population-scale genetic variation, and a more accurate way to analyse genetic variation in an individual’s genome.

Here we seek to assess the feasibility of using the human pangenome to improve childhood cancer genome analysis. We propose to first develop an analysis pipeline using nextflow, specifically for cancer, where we wish to compare the sequence of a patient’s germline genome and their tumour genome. From this, you will then align short-read sequencing data from childhood cancer patients to the draft human pangenome graph (e.g. using vg or giraffe). We then wish to identify important tumour-specific genetic variants from this resulting graph. This will be to the best of our knowledge, the first time this approach has been undertaken for childhood cancer.

## Our Solution
We have created a genomic analysis pipeline using Nextflow to help researchers in their analysis of short-read data with the pangenome by efficiently automating the process of data alignment to the human reference pangenome. This means that instead of manually entering, converting and aligning data samples contained in .bam files to a pangenome graph, researchers are able to input those files into our more streamlined pipeline to automate a process which originally would’ve taken 10 times longer. It also not only reduces the difficulty of detecting structural variation in all genomic contexts but also unveils a new possibility of exploring the functional impact of previously inaccessible variants. 

## How to Use
We have 2 different pipelines available to be run, 
1. **new_pangenome.nf** which can be used to create a new pangenome graph and align data sequences to it.
2. **existing_pangenome.nf** which is used to align a given set of data sequences to an already existing pangenome.

### New Pangnome
This pipeline allows you to create your own pangenome and then align the sequences.
The pipeline runs in the following procedure:
1. Take in a fastq file of the users chosing.
2. Pass the fastq file into FASTQC to produce a HTML report about the fastq alignment.
3. Using the fastq file, the pipelines passes it through vg autoindex to prepare graph creation index files.
4. Using the outputted indexing files, the pipeline passes these through vg giraffe to produce a graph (.gam file).
5. Finally, the graph file is passed through vg stats to check the graph alignment is correct.

To use this pipeline, you would need to download or *git clone* the **new_pangenome.nf** file in the workflow folder and the following modules: **[autoindex](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/autoindex), [fastqc](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/fastqc), [vggiraffe](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/vggiraffe) and [vgstats](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/vgstats)** like this:
```
git clone https://github.com/cjalth/pangenome_pipeline.git
```
To run the pipeline, have the data sequence file in your current directory and run these commands in the terminal:
```
module add fastqc nextflow java
```
```
module load fastqc nextflow java
```
```
nextflow run workflow/new_pangenome.nf
```
All resulting data such as the pangenome graph and the fastqc analysis results would be stored in the [results](https://github.com/cjalth/pangenome_pipeline/tree/main/results) folder


### Existing Pangenome
This pipeline allows you to use a current pangenome and align short reads to it.
The pipeline runs in the following procedure:
1. Takes in an input bam file of the user's choosing.
2. Passes the bam file into MULTIQC to produce a HTML report that summarises it's contents and ensures that the bam file is valid
3. Passes the bam file into SAMTOOLS to extract the fastq file from it.
4. Passes the extracted fastq file into FASTQC to produce a HTML report about the fastq alignment.
5. Using the fastq file, the pipelines passes it through vg autoindex to prepare graph creation index files.
6. Using the outputted indexing files, the pipeline passes these through vg giraffe to produce a graph (.gam file).
7. Finally, the graph file is passed through vg stats to check the graph alignment is correct.

To use this pipeline, you would need to download or *git clone* the **existing_pangenome.nf** file in the workflow folder and the following modules: **[autoindex](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/autoindex), [fastqc](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/fastqc), [multiqc](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/multiqc), [samtools](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/samtools), [vggiraffe](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/vggiraffe) and [vgstats](https://github.com/cjalth/pangenome_pipeline/tree/main/modules/vgstats)** like this:
```
git clone https://github.com/cjalth/pangenome_pipeline.git
```
To run the pipeline, have the data sequence file in your current directory and run these commands in the terminal:
```
module add fastqc nextflow java multiqc samtools/1.14
```
```
module load fastqc nextflow java multiqc samtools/1.14
```
```
nextflow run workflow/existing_pangenome.nf
```
All resulting data such as the pangenome graph, the fastqc analysis results, the multiqc analysis results and the extracted fastq file from the given .bam file would be stored in the [results](https://github.com/cjalth/pangenome_pipeline/tree/main/results) folder


