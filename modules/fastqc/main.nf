params.outdir = 'results'

process FASTQC {
    tag "FASTQC on $sample_id"
    conda 'bioconda::fastqc=0.12.1'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs", emit: logs

    script:
    """
    fastqc.sh "$sample_id" "$reads"
    """
}

workflow {
    FASTQC
}

#!/usr/bin/env nextflow

params.reads = "${launchDir}/data/*.fq.gz"

/**
 * Quality control fastq
 */

reads_ch = Channel
    .fromPath( params.reads )
    
process fastqc {

    input:
    path read  
    
    script:
    """
    fastqc ${read}
    """
}

workflow {
    fastqc(reads_ch)
}
