#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process VGSTATS {
    script:
    """
    /srv/scratch/canpang/vg stats -a /srv/scratch/canpang/pangenome_pipeline/results/graph_results/mapped.gam > /srv/scratch/canpang/pangenome_pipeline/results/graph_results/stats.txt
    """
}