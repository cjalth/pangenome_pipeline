#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process ALIGNMENT {
    output:
    stdout

    script:
    """
    qsub /srv/scratch/canpang/Alignment.pbs
    """
}