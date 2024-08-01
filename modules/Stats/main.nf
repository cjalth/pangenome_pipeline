#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process STATS {
    input:
    val x
    
    output:
    stdout
    
    script:
    """
    qsub /srv/scratch/canpang/VGstats.pbs
    cat /srv/scratch/canpang/RMNISTHS_30xdownsample_allreads_gam_Stats.txt
    """
}