#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.fastq = '/srv/scratch/canpang/pangenome_pipeline/mock_data.fq'

process FASTQC {
    conda 'bioconda::fastqc=0.12.1'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0' :
        'biocontainers/fastqc:0.12.1--hdfd78af_0' }"

    input:
    file fastq

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results
    rm -rf /srv/scratch/canpang/pangenome_pipeline/results/mock_data_fastqc

    fastqc -o /srv/scratch/canpang/pangenome_pipeline/results /srv/scratch/canpang/pangenome_pipeline/mock_data.fq

    unzip -d /srv/scratch/canpang/pangenome_pipeline/results /srv/scratch/canpang/pangenome_pipeline/results/*.zip

    rm /srv/scratch/canpang/pangenome_pipeline/results/*.zip
    rm /srv/scratch/canpang/pangenome_pipeline/results/*.html

    """
}

workflow {
    FASTQC(fastq: params.fastq)
}
    