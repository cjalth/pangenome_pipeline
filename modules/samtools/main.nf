#!/usr/bin/env nextflow

nextflow.enable.dsl = 2


process SAMTOOLS {
    input:
    path bam_file

    output:
    path '../../../results/extracted/extracted.fq'

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/extracted
    touch /srv/scratch/canpang/pangenome_pipeline/results/extracted/extracted.fq
    samtools bam2fq $bam_file > /srv/scratch/canpang/pangenome_pipeline/results/extracted/extracted.fq

    """
}
