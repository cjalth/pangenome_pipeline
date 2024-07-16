#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.reads = "/srv/scratch/canpang/pangenome_pipeline"
params.outdir = "/srv/scratch/canpang/pangenome_pipeline/results"

process MULTIQC {
    conda 'bioconda::multiqc=1.17'

    input:
    file reads

    script:
    """
    mkdir -p ${params.outdir}/multiqc_report
    multiqc $params.reads -o ${params.outdir}/multiqc_report
    """
}

workflow {
    MULTIQC(reads: params.reads)
}

