#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Define input parameters
params.reads = "$PWD/subseq_vann_wt_samples.fna"
params.metadata = "$PWD/metadata.tsv"
params.outdir = "$PWD/qiime1.9.1_analysis/"
params.parameters = "$PWD/docs/parameters_3_original.txt"
params.threads = 8

log.info """\
    QIIME 1.9.1 pipeline
    ===================================
    reads   :  ${params.reads}
    metadata:  ${params.metadata}
    outdir  :  ${params.outdir}
    parameters:  ${params.parameters}
    threads: ${params.threads}
    """
    .stripIndent()

workflow {
    reads = Channel.fromPath(params.reads)
    pick_otus(reads)
}

// Pick closed reference OTUs with GreenGenes 13_8 database
process pick_otus {
    tag "pick_closed_reference_otus.py using GreenGenes 13_8 database on $reads"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path (reads)

    output:
    path "01_pick_closed_gg/*"

    script:
    """
    pick_closed_reference_otus.py -f -a -O ${params.threads} -p ${params.parameters} -i ${reads} -o 01_pick_closed_gg/
    """
}

