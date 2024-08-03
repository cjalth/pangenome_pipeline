# Using the human pangenome to improve childhood cancer genome analysis
The draft human reference genome was published in 2000 and has been improving in quality ever since (now version 38) yet is still missing large swathes of DNA sequences. Furthermore, as researchers have sequenced thousands of individuals, and discovered millions of unique genetic variants, it has become apparent that the linear reference genome is no longer the best way to represent all this genetic variation because:
- It fails to capture the full extent of genetic variation in the human genome,
- Limits researchers' ability to discover new tumour-specific genetic variants,
- Restricts the number of comparisons that can be conducted, 
- It’s inefficiency makes the detection process laborious and time-consuming.

Thus in response, the [pangenome](https://www.nature.com/articles/s41586-023-05896-x#citeas) was created, which is a new approach to storing the reference genome as a graph, with loops in the graph representing each unique genetic variant, meaning each individual has a unique path through the graph. This promises to be both a more efficient way to store population-scale genetic variation and a more accurate way to analyse genetic variation in an individual’s genome.

## Our Solution
We seek to assess the feasibility of using the human pangenome to improve childhood cancer genome analysis. We have created a genomic analysis pipeline using [Nextflow](https://www.nextflow.io/) to help researchers analyse short-read data with the pangenome by efficiently automating the process of data alignment with the human reference pangenome. 

This means that instead of manually entering, converting and aligning data samples contained in .bam files to a pangenome graph, researchers can input those files into our more streamlined pipeline to automate a process that originally would’ve taken 10 times longer. It reduces the difficulty of detecting structural variation in all genomic contexts and unveils a new possibility of exploring the functional impact of previously inaccessible variants. 

Our pipeline aligns short-read sequencing data from specifically childhood cancer patients to the draft human pangenome graph to identify important tumour-specific genetic variants from this resulting graph.

This will be to the best of our knowledge, the first time this approach has been undertaken for childhood cancer.

We have 2 different pipelines available to be run (in the [workflow](https://github.com/cjalth/pangenome_pipeline/tree/main/workflow) directory), 
1. **new_pangenome.nf** which can be used to create a new pangenome graph and align data sequences to it.
2. **existing_pangenome.nf** which is used to align a given set of data sequences to an already existing pangenome.

### New Pangenome
This pipeline allows you to create your own pangenome and then align the sequences.
The pipeline runs in the following procedure:
1. Take in a fastq file of the users chosing.
2. Pass the fastq file into FASTQC to produce a HTML report about the fastq alignment.
3. Using the fastq file, the pipelines passes it through vg autoindex to prepare graph creation index files.
4. Using the outputted indexing files, the pipeline passes these through vg giraffe to produce a graph (.gam file).
5. Finally, the graph file is passed through vg stats to check the graph alignment is correct.

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

## How to Use - UNSW Restech Katana Users
Please navigate to /srv/scratch/canpang/pangenome_pipeline to access the two pipelines.

We have a nextflow config file in /srv/scratch/canpang/pangenome_pipeline where you can pass through a file path (starting from /srv/scratch/canpang/pangenome_pipeline/workflow).
- In nextflow.config we have two parameters: inputbam and inputFastq where you can replace the path to a .BAM File and/or .fq file to suit your research needs (NOTE: inputbam is only read by the exisiting_pangenome.nf and inputFastq is only read by new_pangenome.nf)

### New Pangenome
After changing the 'inputFastq' parameter in nextflow config navigate to the workflow directory and load the necessary modules (Nextflow and FASTQC). This can be done with the following commands:
```
cd workflow
module add nextflow fastqc
module load nextflow fastqc
```

To ensure that the right modules are loaded you can try run ```module list``` and see if both Nextflow and FASTQC are loaded. To now run the pipeline, simply enter:
```
nextflow run new_pangenome.nf -c ../nextflow.config
```

This should run the pipeline and the results from FASTQC and VG Stats will be outputted into the terminal, and more details can be found in ```/srv/scratch/canpang/pangenome_pipeline/results```.

### Existing Pangenome
After changing the 'inputbam' parameter in nextflow.config navigate to the workflow directory and load the necesary modules (Nextflow, MULTIQC, FASTQC and SAMTOOLS). This can be done with the following commands.
```
cd workflow
module add nextflow multiqc samtools/1.14 fastqc 
module load nextflow multiqc samtools/1.14 fastqc 
```

To ensure that the right modules are loaded you can try run ```module list``` and see if all modules are loaded. To now run the pipeline, simply enter:
```
nextflow run existing_pangenome.nf -c ../nextflow.config
```

This should run the pipeline and the results from VG STATS will be outputted into the terminal, and more details can be found in ```/srv/scratch/canpang/pangenome_pipeline/results```.


## How to Use - Non-Katana Users (other HPC Systems or Locally)

To use this tool, you will need to clone this directory through:
```
git clone https://github.com/cjalth/pangenome_pipeline.git
```

You will also need to ensure all modules are downloaded on your system:
- [Nextflow](https://www.nextflow.io/docs/latest/install.html)
- [MultiQC](https://multiqc.info/docs/getting_started/installation/)
- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [Samtools](https://www.htslib.org/download/)
- [VG](https://github.com/vgteam/vg/releases/tag/v1.58.0)

**NOTE:** You may also need to download and update Java to the latest version.

By navigating through each process in the modules directory, simply replace each instance of the module call with the path of your downloaded modules, for example whenever vg is called (vg autoindex, vg giraffe or vg stats) simply change the path to vg to where your own vg folder is located.

We have a nextflow config file in the base directory where you can pass through a file path (starting from the workflow folder).
- In nextflow.config we have two parameters: inputbam and inputFastq where you can replace the path to a .BAM File and/or .fq file to suit your research needs (NOTE: inputbam is only read by the exisiting_pangenome.nf and inputFastq is only read by new_pangenome.nf)

From the base directory navigate to workflow by entering ```cd workflow```.

### New Pangnome

After changing nextflow.config's inputFastq paramter, in the workflow directory you can run the pipeline by running:
```
nextflow run new_pangenome.nf -c ../nextflow.config
```

This should run the pipeline and the results from FASTQC and VG Stats will be outputted into the terminal, and more details can be found in ```/pangenome_pipeline/results```.

### Existing Pangenome

After changing nextflow.config's inputbam paramter, in the workflow directory you can run the pipeline by running:
```
nextflow run existing_pangenome.nf -c ../nextflow.config
```

This should run the pipeline and the results from VG STATS will be outputted into the terminal, and more details can be found in ```/pangenome_pipeline/results```.
