#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Define input parameters
params.reads = '/home/linux/Documents/nextflow_qiiime1/rawdata/allSamples.fna'
params.outdir = '/home/linux/Documents/nextflow_qiiime1/02_qiime1.9.1_analysis/'
params.metadata = '/home/linux/Documents/nextflow_qiiime1/rawdata/mapping.txtmertasdjkasd'

log.info """\
    QIIME 1.9.1 pipeline  
    ===================================
    reads   :  ${params.reads}
    outdir  :  ${params.outdir}
    """
    .stripIndent()

workflow {
    pick_otus(params.reads, params.outdir)
}

// Pick otus
process pick_otus {
    tag "pick_otus"
    publishDir "${params.outdir}/pick_otus", mode: 'copy'
    input:
    file reads from params.reads
    output:
    file 'otus.txt' into otus
    script:
    """
    pick_otus.py -i ${reads} -o otus.txt
    """
}