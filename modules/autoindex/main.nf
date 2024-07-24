#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process VGAUTOINDEX {
    input:
    path fastq

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results
    /srv/scratch/canpang/vg autoindex --workflow giraffe -r $fastq -p /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index
    """
}
