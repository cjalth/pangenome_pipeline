#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process VGSTATS {
    input:
    path gamfile

    output:
    path '../../../../results/graph_results/stats.txt'

    script:
    """
    /srv/scratch/canpang/vg stats -a $gamfile > /srv/scratch/canpang/pangenome_pipeline/results/graph_results/stats.txt
    """
    // qsub VGStats.pbs
    // /srv/scratch/canpang/vg stats -a $gamfile > /srv/scratch/canpang/pangenome_pipeline/results/graph_results/stats.txt
    
}