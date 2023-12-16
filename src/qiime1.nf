#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Define input parameters
params.reads = 'rawdata/*_R{1,2}*.fastq.gz'
params.outdir = 'results/'

log.info """\
    Pretreatment pipeline  
    ===================================
    reads        : ${params.reads}
    outdir       : ${params.outdir}
    """
    .stripIndent()

workflow {
    reads = Channel.fromPath(params.reads)

	fastqc(reads)

    reads = channel.fromFilePairs( params.reads, checkIfExists: true )

    trimmomaticCrop(reads)

}

// Create fastqc files
process fastqc {
    tag "fastqc on $read"
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

// trimmomatic headcrop and crop
process trimmomaticCrop {
    tag "trimmomaticCrop on $sample_id"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(reads)

    output:
    path "01_trimmomaticCrop/*"

    script:
    """
    mkdir 01_trimmomaticCrop/
    trimmomatic SE -phred33 ${reads[0]} 01_trimmomaticCrop/$sample_id\\_R1_hc17_c210.fastq.gz HEADCROP:17 CROP:210
    
    trimmomatic SE -phred33 ${reads[1]} 01_trimmomaticCrop/$sample_id\\_R2_hc21_c210.fastq.gz HEADCROP:21 CROP:210
    """
}
