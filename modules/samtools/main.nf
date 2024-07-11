#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input = "/srv/scratch/canpang/pangenome_pipeline/mock_datab.bam"
params.outdir = "/srv/scratch/canpang/pangenome_pipeline/results"

process SAMTOOLS {
    conda 'bioconda::samtools=1.10'

    input:
    file bam_file

    output:
    path "${params.outdir}/extracted/mock_datab_R1.fastq.gz"
    path "${params.outdir}/extracted/mock_datab_R2.fastq.gz"

    script:
    """
    mkdir -p ${params.outdir}/extracted

    samtools sort -n ${bam_file} -o ${params.outdir}/extracted/mock_datab_sorted.bam

    samtools fastq -@ 8 ${params.outdir}/extracted/mock_datab_sorted.bam \\
        -1 ${params.outdir}/extracted/mock_datab_R1.fastq.gz \\
        -2 ${params.outdir}/extracted/mock_datab_R2.fastq.gz \\
        -0 /dev/null -s /dev/null -n
    """
}

workflow {
    SAMTOOLS(bam_file: params.input)
}

