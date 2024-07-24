#!/bin/bash -ue
mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/multiqc_report
multiqc /srv/scratch/canpang/pangenome_pipeline -o /srv/scratch/canpang/pangenome_pipeline/results/multiqc_report
