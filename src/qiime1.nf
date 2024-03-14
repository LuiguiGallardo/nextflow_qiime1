#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Define input parameters
params.reads = "$PWD/subseq_vann_wt_samples.fna"
params.metadata = "$PWD/metadata.tsv"
params.outdir = "$PWD/qiime1.9.1_analysis/"
params.parameters = "$PWD/nextflow_qiime1/docs/parameters_3_original.txt"
params.silva_database = "$PWD/nextflow_qiime1/docs/silva_132_97_16S.fna.gz"
params.silva_taxonomy = "$PWD/nextflow_qiime1/docs/taxonomy_7_levels.txt.gz"
params.silva_tree = "$PWD/nextflow_qiime1/docs/97_otus.tre.gz"
params.threads = 8

log.info """\
    QIIME 1.9.1 pipeline
    ===================================
    reads   :  ${params.reads}
    metadata:  ${params.metadata}
    outdir  :  ${params.outdir}
    parameters:  ${params.parameters}
    silva_database: ${params.silva_database}
    silva_taxonomy: ${params.silva_taxonomy}
    silva_tree: ${params.silva_tree}
    threads: ${params.threads}
    """
    .stripIndent()

workflow {
    reads = Channel.fromPath(params.reads)
    pick_otus_green_genes(reads)
    pick_otus_silva(reads)
}

// Pick closed reference OTUs with GreenGenes 13_8 database
process pick_otus_green_genes {
    tag "pick_closed_reference_otus.py using GreenGenes 13_8 database on $reads"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path (reads)

    output:
    path "01_pick_closed_gg/*"

    script:
    """
    pick_closed_reference_otus.py -f -a -O ${params.threads} -p ${params.parameters} -i ${reads} -o 01_pick_closed_gg/

    filter_otus_from_otu_table.py -i 01_pick_closed_gg/otu_table.biom -o 01_pick_closed_gg/otu_table_0.01.biom --min_count_fraction 0.0001

    filter_otus_from_otu_table.py -i 01_pick_closed_gg/otu_table.biom -o 01_pick_closed_gg/otu_table_0.005.biom --min_count_fraction 0.00005

    biom summarize-table -i 01_pick_closed_gg/otu_table.biom -o 01_pick_closed_gg/otu_table.txt

    biom summarize-table -i 01_pick_closed_gg/otu_table_0.01.biom -o 01_pick_closed_gg/otu_table_0.01.txt

    biom summarize-table -i 01_pick_closed_gg/otu_table_0.005.biom -o 01_pick_closed_gg/otu_table_0.005.txt

    summarize_taxa.py -i 01_pick_closed_gg/otu_table.biom -o 01_pick_closed_gg/01_sumtax_otu_table --level 2,3,4,5,6,7
    
    summarize_taxa.py -i 01_pick_closed_gg/otu_table_0.01.biom -o 01_pick_closed_gg/02_sumtax_otu_table_0.01 --level 2,3,4,5,6,7

    summarize_taxa.py -i 01_pick_closed_gg/otu_table_0.005.biom -o 01_pick_closed_gg/03_sumtax_otu_table_0.005 --level 2,3,4,5,6,7

    beta_diversity_through_plots.py --suppress_emperor_plots -i 01_pick_closed_gg/otu_table.biom -o 01_pick_closed_gg/04_bdiv_otu_table -t 01_pick_closed_gg/97_otus.tree -e \$(cat 01_pick_closed_gg/otu_table.txt | grep Min | cut -f 3 -d ' ' | sed 's/,//g' | awk '{print \$1 * 0.75}' |cut -f 1 -d . ) -m ${params.metadata}

    make_2d_plots.py -i 01_pick_closed_gg/04_bdiv_otu_table/unweighted_unifrac_pc.txt -o 01_pick_closed_gg/04_bdiv_otu_table/plots_unweighted_unifrac_pc -m ${params.metadata}

    beta_diversity_through_plots.py --suppress_emperor_plots -i 01_pick_closed_gg/otu_table_0.01.biom -o 01_pick_closed_gg/05_bdiv_otu_table_0.01 -t 01_pick_closed_gg/97_otus.tree -e \$(cat 01_pick_closed_gg/otu_table_0.01.txt | grep Min | cut -f 3 -d ' ' | sed 's/,//g' | awk '{print \$1 * 0.75}' |cut -f 1 -d . ) -m ${params.metadata}
    
    make_2d_plots.py -i 01_pick_closed_gg/05_bdiv_otu_table_0.01/unweighted_unifrac_pc.txt -o 01_pick_closed_gg/05_bdiv_otu_table_0.01/plots_unweighted_unifrac_pc -m ${params.metadata}

    beta_diversity_through_plots.py --suppress_emperor_plots -i 01_pick_closed_gg/otu_table_0.005.biom -o 01_pick_closed_gg/06_bdiv_otu_table_0.005 -t 01_pick_closed_gg/97_otus.tree -e \$(cat 01_pick_closed_gg/otu_table_0.005.txt | grep Min | cut -f 3 -d ' ' | sed 's/,//g' | awk '{print \$1 * 0.75}' |cut -f 1 -d . ) -m ${params.metadata}

    make_2d_plots.py -i 01_pick_closed_gg/06_bdiv_otu_table_0.005/unweighted_unifrac_pc.txt -o 01_pick_closed_gg/06_bdiv_otu_table_0.005/plots_unweighted_unifrac_pc -m ${params.metadata}
    """
}

// Pick closed reference OTUs with Silva 132 database
process pick_otus_silva {
    tag "pick_closed_reference_otus.py using Silva 132 database on $reads"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path (reads)

    output:
    path "02_pick_closed_silva/*"

    script:
    """
    gunzip -c ${params.silva_database} > silva_132_97_16S.fna
    gunzip -c ${params.silva_taxonomy} > taxonomy_7_levels.txt
    gunzip -c ${params.silva_tree} > 97_otus.tre

    pick_closed_reference_otus.py -f -a -O ${params.threads} -p ${params.parameters} -i ${reads} -o 02_pick_closed_silva/ -t taxonomy_7_levels.txt -r silva_132_97_16S.fna

    filter_otus_from_otu_table.py -i 02_pick_closed_silva/otu_table.biom -o 02_pick_closed_silva/otu_table_0.01.biom --min_count_fraction 0.0001

    filter_otus_from_otu_table.py -i 02_pick_closed_silva/otu_table.biom -o 02_pick_closed_silva/otu_table_0.005.biom --min_count_fraction 0.00005

    biom summarize-table -i 02_pick_closed_silva/otu_table.biom -o 02_pick_closed_silva/otu_table.txt

    biom summarize-table -i 02_pick_closed_silva/otu_table_0.01.biom -o 02_pick_closed_silva/otu_table_0.01.txt

    biom summarize-table -i 02_pick_closed_silva/otu_table_0.005.biom -o 02_pick_closed_silva/otu_table_0.005.txt

    summarize_taxa.py -i 02_pick_closed_silva/otu_table.biom -o 02_pick_closed_silva/01_sumtax_otu_table --level 2,3,4,5,6,7
    
    summarize_taxa.py -i 02_pick_closed_silva/otu_table_0.01.biom -o 02_pick_closed_silva/02_sumtax_otu_table_0.01 --level 2,3,4,5,6,7

    summarize_taxa.py -i 02_pick_closed_silva/otu_table_0.005.biom -o 02_pick_closed_silva/03_sumtax_otu_table_0.005 --level 2,3,4,5,6,7

    beta_diversity_through_plots.py --suppress_emperor_plots -i 02_pick_closed_silva/otu_table.biom -o 02_pick_closed_silva/04_bdiv_otu_table -t 97_otus.tre -e \$(cat 02_pick_closed_silva/otu_table.txt | grep Min | cut -f 3 -d ' ' | sed 's/,//g' | awk '{print \$1 * 0.75}' |cut -f 1 -d . ) -m ${params.metadata}

    make_2d_plots.py -i 02_pick_closed_silva/04_bdiv_otu_table/unweighted_unifrac_pc.txt -o 02_pick_closed_silva/04_bdiv_otu_table/plots_unweighted_unifrac_pc -m ${params.metadata}

    beta_diversity_through_plots.py --suppress_emperor_plots -i 02_pick_closed_silva/otu_table_0.01.biom -o 02_pick_closed_silva/05_bdiv_otu_table_0.01 -t 97_otus.tre -e \$(cat 02_pick_closed_silva/otu_table_0.01.txt | grep Min | cut -f 3 -d ' ' | sed 's/,//g' | awk '{print \$1 * 0.75}' |cut -f 1 -d . ) -m ${params.metadata}

    make_2d_plots.py -i 02_pick_closed_silva/05_bdiv_otu_table_0.01/unweighted_unifrac_pc.txt -o 02_pick_closed_silva/05_bdiv_otu_table_0.01/plots_unweighted_unifrac_pc -m ${params.metadata}

    beta_diversity_through_plots.py --suppress_emperor_plots -i 02_pick_closed_silva/otu_table_0.005.biom -o 02_pick_closed_silva/06_bdiv_otu_table_0.005 -t 97_otus.tre -e \$(cat 02_pick_closed_silva/otu_table_0.005.txt | grep Min | cut -f 3 -d ' ' | sed 's/,//g' | awk '{print \$1 * 0.75}' |cut -f 1 -d . ) -m ${params.metadata}

    make_2d_plots.py -i 02_pick_closed_silva/06_bdiv_otu_table_0.005/unweighted_unifrac_pc.txt -o 02_pick_closed_silva/06_bdiv_otu_table_0.005/plots_unweighted_unifrac_pc -m ${params.metadata}
    """
}