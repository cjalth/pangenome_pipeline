#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input = "/srv/scratch/canpang/pangenome_pipeline/Test1-ready.bam"
params.outdir = "/srv/scratch/canpang/pangenome_pipeline/results"

process SAMTOOLS {
    conda 'bioconda::samtools=1.14'

    input:
    path bam_file

    script:
    """
    mkdir -p extracted
    samtools bam2fq ${bam_file} -o 
    -n ${bam_file} -o extracted/mock_datab_sorted.bam

    samtools fastq -@ 8 extracted/mock_datab_sorted.bam \\
        -1 extracted/mock_datab_R1.fastq.gz \\
        -2 extracted/mock_datab_R2.fastq.gz \\
        -0 /dev/null -s /dev/null -n
    """
}


process MOVE_FILES {
    input:
    path "extracted/mock_datab_R1.fastq.gz"
    path "extracted/mock_datab_R2.fastq.gz"

    script:
    """
    mkdir -p ${params.outdir}/extracted
    mv extracted/* ${params.outdir}/extracted/
    """
}

workflow {
    SAMTOOLS(bam_file: params.input)
    MOVE_FILES(extracted_files)
}
