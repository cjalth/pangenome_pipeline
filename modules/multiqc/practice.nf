#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.input = "/data/bio/giab/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/RMNISTHS_30xdownsample.bam"
params.outdir = "/srv/scratch/canpang/pangenome_pipeline/results"

process SAMTOOLS_STATS {
    conda 'bioconda::samtools=1.14'

    input:
    file input

    output:
    path "/srv/scratch/canpang/pangenome_pipeline/results/samtools_stats/bam.txt"

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats
    samtools stats /data/bio/giab/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/RMNISTHS_30xdownsample.bam > /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats/bam.txt
    """
}

process MULTIQC {
    conda 'bioconda::multiqc=1.17'

    input:
    file samtools_output

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/multiqc_report
    multiqc /srv/scratch/canpang/pangenome_pipeline/results/samtools_stats/bam.txt -o /srv/scratch/canpang/pangenome_pipeline/results/multiqc_report
    """
}

workflow {
    samtools_output = SAMTOOLS_STATS(bam_file: params.input)
    MULTIQC(samtools_output)
}