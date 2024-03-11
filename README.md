# nextflow_qiiime1
QIIME 1.9.1 Nextflow pipeline

Tested with Nextflow 23.10.0.

Example of usage: 
```bash
nextflow src/qiime1.nf --reads "$PWD/rawdata/*_R{1,2}*.fastq.gz" --outdir "$PWD/results/" --qiime_fasta_formatter "$PWD/src/QIIME_fasta_formatter.pl"
```