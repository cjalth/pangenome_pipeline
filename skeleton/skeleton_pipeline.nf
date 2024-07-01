#!/usr/bin/env nextflow

// Define the parameters
params.bam = 'input.bam'
params.outdir = './results'

// Define the process for MultiQC
process multiqc {
    input:
    path bam

    output:
    path "${params.outdir}/multiqc_report.html"

    script:
    """
    multiqc $bam -o ${params.outdir}
    """
}

// Define the process for Samtools to convert BAM to FASTA
process samtools_fasta {
    input:
    path bam

    output:
    path "${params.outdir}/output.fasta"

    script:
    """
    samtools fasta $bam > ${params.outdir}/output.fasta
    """
}

// Define the process for FastQC
process fastqc {
    input:
    path fasta

    output:
    path "${params.outdir}/fastqc_report"

    script:
    """
    fastqc $fasta -o ${params.outdir}/fastqc_report
    """
}

// Define the process for VG stats
process vg_stats {
    input:
    path fasta

    output:
    path "${params.outdir}/vg_stats.txt"

    script:
    """
    vg stats -F -a ${params.outdir}/vg_stats.txt $fasta
    """
}

// Define the process for VG giraffe
process vg_giraffe {
    input:
    path fasta

    output:
    path "${params.outdir}/vg_graph.gfa"

    script:
    """
    vg giraffe -G $fasta > ${params.outdir}/vg_graph.gfa
    """
}

// Define the workflow
workflow {
    Channel.fromPath(params.bam)
        .set { bam_ch }

    bam_ch |>
    multiqc |>
    samtools_fasta |>
    fastqc |>
    vg_stats |>
    vg_giraffe
}
