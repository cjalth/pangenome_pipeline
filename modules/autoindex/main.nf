#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process VGAUTOINDEX {
    input:
    path fastq

    output:
    path '../../../../results/autoindex_results'

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results

    # Create the index files in the work directory
    /srv/scratch/canpang/vg autoindex --workflow giraffe -r $fastq -p index

    # Move the index files to the final directory
    mv index.giraffe.gbz /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/
    mv index.min /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/
    mv index.dist /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/
    """
}
