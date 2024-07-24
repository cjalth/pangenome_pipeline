#!/bin/bash -ue
mkdir -p /srv/scratch/canpang/pangenome_pipeline/results
find /srv/scratch/canpang/pangenome_pipeline/results/ -type d -name '*_fastqc' -exec rm -rf {} +

fastqc -o /srv/scratch/canpang/pangenome_pipeline/results mock_data.fq
unzip -d /srv/scratch/canpang/pangenome_pipeline/results /srv/scratch/canpang/pangenome_pipeline/results/*.zip

rm /srv/scratch/canpang/pangenome_pipeline/results/*.zip
rm /srv/scratch/canpang/pangenome_pipeline/results/*.html
