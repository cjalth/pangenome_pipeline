params.outdir = 'results'

// Define the process for Samtools to convert BAM to FASTQ
process samtools_fasta {
    input:
    path bam

    output:
    path "${params.outdir}/seq.1.fastq", emit: seq1
    path "${params.outdir}/seq.2.fastq", emit: seq2

    script:
    """
    mkdir -p ${params.outdir}

    samtools fasta $bam > ${params.outdir}/output.fasta

    samtools view -u -f 1 -F 12 $bam > map_map.bam
    samtools view -u -f 4 -F 264 $bam > unmap_map.bam
    samtools view -u -f 8 -F 260 $bam > map_unmap.bam
    samtools view -u -f 12 -F 256 $bam > unmap_unmap.bam

    samtools merge -u unmapped.bam unmap_map.bam map_unmap.bam unmap_unmap.bam

    samtools sort -n map_map.bam mapped.sort
    samtools sort -n unmapped.bam unmapped.sort

    bamToFastq -i mapped.sort.bam -fq ${params.outdir}/mapped.1.fastq -fq2 ${params.outdir}/mapped.2.fastq
    bamToFastq -i unmapped.sort.bam -fq ${params.outdir}/unmapped.1.fastq -fq2 ${params.outdir}/unmapped.2.fastq

    cat ${params.outdir}/mapped.1.fastq ${params.outdir}/unmapped.1.fastq > ${params.outdir}/seq.1.fastq
    cat ${params.outdir}/mapped.2.fastq ${params.outdir}/unmapped.2.fastq > ${params.outdir}/seq.2.fastq
    """
}