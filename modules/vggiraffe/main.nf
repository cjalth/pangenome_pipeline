#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process VGGIRAFFE {
    input:
    path fastq

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/graph_results
    /srv/scratch/canpang/vg giraffe -Z /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.giraffe.gbz -m /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.min -d /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.dist -f $fastq > /srv/scratch/canpang/pangenome_pipeline/results/graph_results/mapped.gam

    /srv/scratch/canpang/vg view -a /srv/scratch/canpang/pangenome_pipeline/results/graph_results/mapped.gam > /srv/scratch/canpang/pangenome_pipeline/results/graph_results/mapped.json
    """
}