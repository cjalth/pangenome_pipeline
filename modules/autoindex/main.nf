#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.fastq = '/srv/scratch/canpang/pangenome_pipeline/mock_data.fq'

process VGAUTOINDEX {
    input:
    file fastq

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results
    /srv/scratch/canpang/vg autoindex --workflow giraffe -r /srv/scratch/canpang/pangenome_pipeline/mock_data.fq -p /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index
    """
}

workflow {
    VGAUTOINDEX(fastq: params.fastq)
}
