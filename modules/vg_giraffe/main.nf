#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.gbz = '/srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.giraffe.gbz'
params.min = '/srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.min'
params.dist = '/srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.dist'
params.input = '/srv/scratch/canpang/pangenome_pipeline/mock_data.fq'
params.outdir = '/srv/scratch/canpang/pangenome_pipeline/results'

process VGGIRAFFE {
    input:
    file min
    file dist
    file giraffe

    script:
    """
    mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/giraffe_results
    
    /srv/scratch/canpang/vg giraffe -Z /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.giraffe.gbz -m /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.min -d /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.dist -f /srv/scratch/canpang/pangenome_pipeline/mock_data.fq > /srv/scratch/canpang/pangenome_pipeline/results/giraffe_results/mapped.gam
    
    """
}

workflow {
    VGGIRAFFE(min: /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.min, dist: /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.dist, giraffe: /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index.giraffe.gbz)
}
