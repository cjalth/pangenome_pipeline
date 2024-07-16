#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.gbz = '/srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.giraffe.gbz'
params.min = '/srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.min'
params.dist = '/srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.dist'
params.input = '/srv/scratch/canpang/pangenome_pipeline/mock_data.fq'
params.outdir = '/srv/scratch/canpang/pangenome_pipeline/results'

process VGGIRAFFE {
    input:
    file fastq

    output:
    path "${params.outdir}/giraffe_results/mapped.gam"

    script:
    """
    mkdir -p ${params.outdir}/giraffe_results
    
    /srv/scratch/canpang/vg giraffe -Z ${params.gbz} -m ${params.min} -d ${params.dist} -f ${fastq} -o gam > ${params.outdir}/giraffe_results/mapped.gam
    
    """
}

workflow {
    VGGIRAFFE(fastq: params.input)
}
