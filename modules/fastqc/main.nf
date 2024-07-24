#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process FASTQC {
    conda 'bioconda::fastqc=0.12.1'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0' :
        'biocontainers/fastqc:0.12.1--hdfd78af_0' }"

    input:
    path fastq

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results
    find /srv/scratch/canpang/pangenome_pipeline/results/ -type d -name '*_fastqc' -exec rm -rf {} +

    fastqc -o /srv/scratch/canpang/pangenome_pipeline/results $fastq
    unzip -d /srv/scratch/canpang/pangenome_pipeline/results /srv/scratch/canpang/pangenome_pipeline/results/*.zip

    rm /srv/scratch/canpang/pangenome_pipeline/results/*.zip
    rm /srv/scratch/canpang/pangenome_pipeline/results/*.html 
    """
}
