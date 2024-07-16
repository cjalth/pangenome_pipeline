#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input = '/srv/scratch/canpang/pangenome_pipeline/results/giraffe_results/mapped.gam'

process VGSTATS {
    input:
    path gam_file from params.input

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/stats_results
    /srv/scratch/canpang/vg stats -a /srv/scratch/canpang/pangenome_pipeline/results/giraffe_results/mapped.gam > /srv/scratch/canpang/pangenome_pipeline/results/stats.txt
    
    """
}

workflow {
    VGSTATS(gam_file: /srv/scratch/canpang/pangenome_pipeline/giraffe_results/mapped.gam)
}
