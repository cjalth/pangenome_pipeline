#!/bin/bash -ue
mkdir -p /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results
/srv/scratch/canpang/vg autoindex --workflow giraffe -r mock_data.fq -p /srv/scratch/canpang/pangenome_pipeline/results/autoindex_results/index
