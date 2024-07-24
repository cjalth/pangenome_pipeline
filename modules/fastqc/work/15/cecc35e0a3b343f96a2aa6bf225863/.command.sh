#!/bin/bash -ue
mkdir -p /srv/scratch/canpang/pangenome_pipeline/results
rm -rf /srv/scratch/canpang/pangenome_pipeline/results/mock_data_fastqc

fastqc -o /srv/scratch/canpang/pangenome_pipeline/results /srv/scratch/canpang/pangenome_pipeline/mock_data.fq
unzip -d /srv/scratch/canpang/pangenome_pipeline/results /srv/scratch/canpang/pangenome_pipeline/results/*.zip

rm /srv/scratch/canpang/pangenome_pipeline/results/*.zip
rm /srv/scratch/canpang/pangenome_pipeline/results/*.html
