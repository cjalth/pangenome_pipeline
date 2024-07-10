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

// Define the process for Samtools to convert BAM to FASTQ
process samtools_fasta {
    input:
    path bam

    output:
    path "${params.outdir}/output.fasta"

    script:
    """
    samtools fasta $bam > ${params.outdir}/output.fasta

    samtools view -u -f 1 -F 12 $bam > map_map.bam
    samtools view -u -f 4 -F 264 $bam > unmap_map.bam
    samtools view -u -f 8 -F 260 $bam > map_unmap.bam
    samtools view -u -f 12 -F 256 $bam > unmap_unmap.bam

    samtools merge -u unmapped.bam unmap_map.bam map_unmap.bam unmap_unmap.bam

    samtools sort -n map_map.bam mapped.sort
    samtools sort -n unmapped.bam unmapped.sort

    bamToFastq -i mapped.sort.bam -fq mapped.1.fastq -fq2 mapped.2.fastq
    bamToFastq -i unmapped.sort.bam -fq unmapped.1.fastq -fq2 unmapped.2.fastq

    cat mapped.1.fastq unmapped.1.fastq > seq.1.fastq
    cat mapped.2.fastq unmapped.2.fastq > seq.2.fastq
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
