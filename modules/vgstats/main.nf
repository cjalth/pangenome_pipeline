#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.fastq = '/srv/scratch/canpang/pangenome_pipeline/mock_data.fq'

process VGSTATS {
    input:
    file fastq

    script:
    """
    mkdir autoindex_results
    /srv/scratch/canpang/vg autoindex --workflow giraffe -r /srv/scratch/canpang/pangenome_pipeline/mock_data.fq
    """
}

workflow {
    VGSTATS(fastq: params.fastq)
}