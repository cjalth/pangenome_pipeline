#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process MULTIQC {
    input:
    path bam

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats
    touch /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats/bam.txt
    samtools stats $bam > /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats/bam.txt

    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/multiqc_report
    multiqc /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats/bam.txt -o /srv/scratch/canpang/pangenome_pipeline/results/multiqc_report

    rm -rf /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats
    """
}
