# nextflow_qiiime1
QIIME 1.9.1 Nextflow pipeline

Tested with Nextflow 23.10.0.

Dependencies for pretreatment: fastqc, trimmomatic, fastq-join, and fastx_toolkit.

```bash
conda install -c bioconda fastqc trimmomatic fastq-join fastx_toolkit
```

Example of usage: 
```bash
# For pretreatment
nextflow src/qiime1_pretreatment.nf --reads "$PWD/00_rawdata/*_R{1,2}*.fastq.gz" --outdir "$PWD/01_pretreatment/" --qiime_fasta_formatter "$PWD/src/QIIME_fasta_formatter.pl"

# Merge of final fasta files
cat 01_pretreatment/04_fastqToFasta/*.fna > larva_adult_2025.fna
```

Dependencies for qiime1.9.1 analyses docker with the image `stang/qiime1.9:v1`

```bash
# To obtain the docker image
pull docker stang/qiime1.9:v1

# qiime1.9.1 pipeline with GreenGenes and Silva databases
nextflow src/qiime1.nf --reads "$PWD/larva_adult_2025.fna" --metadata "$PWD/metadata.tsv" --outdir "$PWD/02_qiime1.9.1_output" --threads 16
```