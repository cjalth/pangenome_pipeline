#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input = '/srv/scratch/canpang/pangenome_pipeline/'
params.outdir = '/srv/scratch/canpang/pangenome_pipeline/results'

process MULTIQC {
    conda 'bioconda::multiqc=1.17'
    publishDir params.outdir, mode: 'copy'

    input:
    path bam_file

    output:
    path "${params.outdir}/multiqc_report.html", emit: report

    script:
    """
    mkdir -p ${params.outdir}
    multiqc $bam_file -o ${params.outdir}
    """
}

workflow {
    MULTIQC(bam_file: file(params.input))
}



