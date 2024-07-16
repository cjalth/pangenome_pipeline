#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input = '/srv/scratch/canpang/pangenome_pipeline/results/giraffe_results/mapped.gam'
params.outdir = '/srv/scratch/canpang/pangenome_pipeline/results'

process VGSTATS {
    input:
    path gam_file from params.input

    output:
    path "${params.outdir}/stats_results/stats_file"

    script:
    """
    mkdir -p ${params.outdir}/stats_results
    /srv/scratch/canpang/vg stats -a ${gam_file} > ${params.outdir}/stats_results/stats_file
    
    """
}

workflow {
    VGSTATS(gam_file: params.input)
}