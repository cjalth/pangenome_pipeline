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
    fastq: $params.inputFile

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
include { VGSTATS     } from '../modules/vgstats/main.nf'

process AggregateResults {
    input:
    path fastq_file
    path fastqcResults
    path statsFile

    output:
    stdout

    script:
    """
    echo "\n<----- Analysis Ready for $fastq_file ----->"

    echo "\n<--- FASTQC Summary --->"
    sed 's/$fastq_file//g' $fastqcResults > tmp_fastqc_results.txt
    cat tmp_fastqc_results.txt

    echo "\n<--- VGSTATS Summary --->"
    cat $statsFile

    echo "\nFor more detailed results locate the results folder from the base directory"
    """
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
workflow {
    // Step 1: Run FASTQC
    fastqc_results = FASTQC(fastq_file)

    // Step 2: Run VGAUTOINDEX
    autoindex_results = VGAUTOINDEX(fastq_file)

    // Step 3: Run VGGIRAFFE using the autoindex output
    gamfile = VGGIRAFFE(fastq_file, autoindex_results)

    // Step 4: Run VGSTATS using the giraffe output and view the result
    stats = VGSTATS(gamfile)

    // Step 5: Aggregate and display results
    results = AggregateResults(fastq_file, fastqc_results, stats)

    // View aggregated results
    results.view()
}