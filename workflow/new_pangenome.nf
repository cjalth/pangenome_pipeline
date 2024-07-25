#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    INPUT FILE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
params.inputFastq = "../mock_data.fq"

fastq_file = Channel
    .fromPath( params.inputFastq )

/*
 * Provide workflow description and default param values to user
 */
log.info """\

============================================================================================================================================
██████╗  █████╗ ███╗   ██╗ ██████╗ ███████╗███╗   ██╗ ██████╗ ███╗   ███╗███████╗    ██████╗ ██╗██████╗ ███████╗██╗     ██╗███╗   ██╗███████╗
██╔══██╗██╔══██╗████╗  ██║██╔════╝ ██╔════╝████╗  ██║██╔═══██╗████╗ ████║██╔════╝    ██╔══██╗██║██╔══██╗██╔════╝██║     ██║████╗  ██║██╔════╝
██████╔╝███████║██╔██╗ ██║██║  ███╗█████╗  ██╔██╗ ██║██║   ██║██╔████╔██║█████╗      ██████╔╝██║██████╔╝█████╗  ██║     ██║██╔██╗ ██║█████╗  
██╔═══╝ ██╔══██║██║╚██╗██║██║   ██║██╔══╝  ██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══╝      ██╔═══╝ ██║██╔═══╝ ██╔══╝  ██║     ██║██║╚██╗██║██╔══╝  
██║     ██║  ██║██║ ╚████║╚██████╔╝███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║███████╗    ██║     ██║██║     ███████╗███████╗██║██║ ╚████║███████╗
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝                      
=============================================================================================================================================

This pipeline allows you to create your own pangenome and then align the sequences.
The pipeline runs in the following procedure:
    1. Take in a fastq file of the users chosing.
    2. Pass the fastq file into FASTQC to produce a HTML report about the fastq alignment.
    3. Using the fastq file, the pipelines passes it through vg autoindex to prepare graph creation index files.
    4. Using the outputted indexing files, the pipeline passes these through vg giraffe to produce a graph (.gam file).
    5. Finally, the graph file is passed through vg stats to check the graph alignment is correct.

Input:
    fastq: ${params.inputFile}

Output:
    Output folders - All results will be in /results 
        a) FASTQC output folder: '/results/{fastq_filename}_fastqc'
        b) Autoindex output folder: '/results/autoindex_results'
        c) Graph file folder: '/results/graph_results'
"""

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { FASTQC      } from '../modules/fastqc/main.nf'
include { VGAUTOINDEX } from '../modules/autoindex/main.nf'
include { VGGIRAFFE   } from '../modules/vggiraffe/main.nf'
include { VGSTATS      } from '../modules/vgstats/main.nf'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
workflow {
    FASTQC(fastq_file)
    VGAUTOINDEX(fastq_file)
    VGGIRAFFE(fastq_file)

    VGSTATS()
}