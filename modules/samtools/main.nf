#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input = "/data/bio/giab/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/RMNISTHS_30xdownsample.bam"
params.outdir = "/srv/scratch/canpang/pangenome_pipeline/results"

process SAMTOOLS {
    conda 'bioconda::samtools=1.14'

    input:
    file bam_file

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/extracted
    touch /srv/scratch/canpang/pangenome_pipeline/results/extracted/extracted_bam1.fq
    samtools bam2fq /data/bio/giab/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/RMNISTHS_30xdownsample.bam > /srv/scratch/canpang/pangenome_pipeline/results/extracted/extracted_bam1.fq

    """
}

workflow {
    SAMTOOLS(bam_file: params.input)
}
