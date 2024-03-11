#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Define input parameters
params.reads = '/home/linux/Documents/nextflow_qiiime1/rawdata/*_R{1,2}*.fastq.gz'
params.outdir = '/home/linux/Documents/nextflow_qiiime1/01_pretreatment'
params.qiime_fasta_formatter = '/home/linux/Documents/nextflow_qiiime1/src/QIIME_fasta_formatter.pl'

log.info """\
    Pretreatment pipeline  
    ===================================
    reads   :  ${params.reads}
    outdir  :  ${params.outdir}
    qiime_fasta_formatter   :  ${params.qiime_fasta_formatter} 
    """
    .stripIndent()

workflow {
    reads = Channel.fromPath(params.reads)
	fastqc(reads)

    reads = channel.fromFilePairs(params.reads, checkIfExists: true )
    trimmomaticCrop(reads)

    fastqJoin(trimmomaticCrop.out)

    slidingWindow(fastqJoin.out)

    fastqToFasta(slidingWindow.out, params.qiime_fasta_formatter)
}

// Create fastqc files
process fastqc {
    publishDir "${params.outdir}", mode: 'copy'

    tag "fastqc on $read"

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

// Trimmomatic headcrop and crop
process trimmomaticCrop {
    publishDir "${params.outdir}/01_trimmomaticCrop", mode: 'copy'
    
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("$sample_id/*_R{1,2}*.fastq.gz")

    script:
    """
    mkdir $sample_id
    trimmomatic SE -phred33 ${reads[0]} $sample_id/$sample_id\\_R1_hc17_c210.fastq.gz HEADCROP:17 CROP:210
    
    trimmomatic SE -phred33 ${reads[1]} $sample_id/$sample_id\\_R2_hc21_c210.fastq.gz HEADCROP:21 CROP:210
    """
}

// Fastq-join with R1 and R2
process fastqJoin {
    publishDir "${params.outdir}/02_fastqJoin", mode: 'copy'

    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("$sample_id/*join.fastq.gz")

    script:
    """
    mkdir $sample_id
    fastq-join -m 6 -p 30 ${reads[0]} ${reads[1]} -o $sample_id/$sample_id\\_
    for s in $sample_id/* ; do mv \$s \$s.fastq ; gzip \$s.fastq ; done
    """
}

// Sliding window 6:20
process slidingWindow {
    publishDir "${params.outdir}/03_slidingWindow", mode: 'copy'

    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("$sample_id/*")

    script:
    """
    mkdir $sample_id
    trimmomatic SE -phred33 $reads $sample_id/$sample_id\\_sw620.fastq.gz SLIDINGWINDOW:6:20
    """
}

// Fastq to fasta
process fastqToFasta {
    publishDir "${params.outdir}/04_fastqToFasta", mode: 'copy'

    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)
    path (qiime_fasta_formatter)

    output:
    path("*.fna")

    script:
    """
    zcat $reads | fastq_to_fasta > $sample_id\\.fasta
    perl $qiime_fasta_formatter -i .
    """
}

