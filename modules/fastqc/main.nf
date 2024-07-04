#!/usr/bin/env nextflow

params.fastq = params.fastq ?: ''

if (!params.fastq) {
    error 'Please provide a FASTQ file using --fastq'
}

process runFastQC {

    input:
    file fastq from file(params.fastq)

    output:
    file("*.html") into qc_results

    script:
    """
    fastqc $fastq
    """
}

workflow {
    runFastQC()
}
