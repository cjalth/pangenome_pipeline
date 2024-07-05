#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.fastq = '../../mock.fq'

process FASTQC {
    conda 'bioconda::fastqc=0.12.1'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0' :
        'biocontainers/fastqc:0.12.1--hdfd78af_0' }"

    input:
    file fastq

    script:
    """
    mkdir -p fastqc_results
    fastqc $fastq

    for zip in fastqc_results/*.zip
    do
        unzip -d fastqc_results ${zip}
    done

    rm fastqc_results/*.zip
    rm fastqc_results/*.html
    """
}

workflow {
    FASTQC(fastq: params.fastq)
}

