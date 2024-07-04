#!/usr/bin/env nextflow

params.fastq = file(params.fastq)

process FASTQC {

    input:
    file fastq from params.fastq

    output:
    file("*.html") into qc_results

    script:
    """
    fastqc $fastq
    """
}

workflow {
    FASTQC()
}
