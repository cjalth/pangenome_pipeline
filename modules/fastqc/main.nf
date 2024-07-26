#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

process FASTQC {
    input:
    path fastq

    output:
    path 'summary.txt'

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results
    find /srv/scratch/canpang/pangenome_pipeline/results/ -type d -name '*_fastqc' -exec rm -rf {} +

    fastqc -o /srv/scratch/canpang/pangenome_pipeline/results $fastq
    unzip -d /srv/scratch/canpang/pangenome_pipeline/results /srv/scratch/canpang/pangenome_pipeline/results/*.zip > /dev/null 2>&1

    rm /srv/scratch/canpang/pangenome_pipeline/results/*.zip > /dev/null 2>&1
    rm /srv/scratch/canpang/pangenome_pipeline/results/*.html > /dev/null 2>&1

    summary_dir=\$(find /srv/scratch/canpang/pangenome_pipeline/results/ -type d -name '*_fastqc')
    cp \${summary_dir}/summary.txt summary.txt
    """
}
