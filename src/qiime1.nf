#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Define input parameters
params.reads = 'rawdata/*_R{1,2}*.fastq.gz'
params.outdir = 'results/'

log.info """\
    R N A S E Q  P I P E L I N E    
    ===================================
    reads        : ${params.reads}
    outdir       : ${params.outdir}
    """
    .stripIndent()

workflow {
    reads_ch = Channel.fromPath(params.reads)

	fastqc(reads_ch)
}

// Create fastqc files
process fastqc {
    // tag "FASTQC on $read"
    publishDir params.outdir

    input:
    path read

	output:
	path "00_fastqc/${read}"

	script:
    """
    mkdir 00_fastqc/ 00_fastqc/${read}
    fastqc ${read} -o 00_fastqc/${read}
    """
}

// process FASTQC {
//     tag "FASTQC on $sample_id"
//     publishDir params.outdir
 
//     input:
//     tuple val(sample_id), path(reads)
 
//     output:
//     path "fastqc_${sample_id}_logs"
 
//     script:
//     """
//     fastqc "$sample_id" "$reads"
//     """
// }



// workflow {
//     read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true )
 
//     // INDEX(params.transcriptome)
//     FASTQC(read_pairs_ch)
//     // QUANT(INDEX.out, read_pairs_ch)
// }