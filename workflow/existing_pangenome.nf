#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    INPUT BAM FILE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
params.bam = '../../../../../data/bio/giab/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/RMNISTHS_30xdownsample.bam'
params.bamfile = './Test1-ready.bam'


bam_file = Channel
    .fromPath( params.bamfile )

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

This pipeline allows you to use a current pangenome and align short reads to it.
The pipeline runs in the following procedure:
    1. Takes in an input bam file of the user's choosing.
    2. Passes the bam file into MULTIQC to produce a HTML report that 
       summarises it's contents and ensures that the bam file is valid
    3. Passes the bam file into SAMTOOLS to extract the fastq file from it.
    4. Passes the extracted fastq file into FASTQC to produce a HTML report about the fastq alignment.
    5. Using the fastq file, the pipelines passes it through vg autoindex to prepare graph creation index files.
    6. Using the outputted indexing files, the pipeline passes these through vg giraffe to produce a graph (.gam file).
    7. Finally, the graph file is passed through vg stats to check the graph alignment is correct.

Input:
    bam: ${params.inputbam}

Output:
    Output folders - All results will be in /results 
        
"""

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { FASTQC      } from '../modules/fastqc/main.nf'
include { MULTIQC     } from '../modules/multiqc/main.nf'
include { SAMTOOLS    } from '../modules/samtools/main.nf'
include { VGAUTOINDEX } from '../../Alignment.pbs'

process AggregateResults {
    input:
    path bam_file
    path fastq_file
    path fastqcResults
    path statsFile

    output:
    stdout

    script:
    """
    echo "\n<----- Analysis Ready for $bam_file ----->"

    echo "\n<--- MULTIQC Successful for $bam_file --->"

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
    // Step 1: Run BAM File Through MULTIQC
    MULTIQC(bam_file)

    // Step 2: Extract Fastq file from BAM file
    fastq_file = SAMTOOLS(bam_file)

    // Step 3: Run FASTQC
    //fastqc_results = FASTQC(fastq_file)

    // Step 4: Run VGAUTOINDEX
    //autoindex_results = VGAUTOINDEX(fastq_file)

    // Step 5: Run VGGIRAFFE using the autoindex output - pbs
    //gamfile = VGGIRAFFE(fastq_file, autoindex_results)

    // Step 6: Run VGSTATS using the giraffe output and view the result - pbs
   // stats = VGSTATS(gamfile)

    // Step 7: Aggregate and display results
    //results = AggregateResults(bam_file, fastq_file, fastqc_results, stats)
   // results.view()
}