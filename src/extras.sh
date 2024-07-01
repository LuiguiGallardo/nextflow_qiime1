
make_2d_plots.py -i 01_pick_closed_gg/04_bdiv_otu_table/weighted_unifrac_pc.txt -o 01_pick_closed_gg/04_bdiv_otu_table/plots_weighted_unifrac_pc -m ../00_rawdata/metadata.tsv 

make_2d_plots.py -i 01_pick_closed_gg/05_bdiv_otu_table_0.01/weighted_unifrac_pc.txt -o 01_pick_closed_gg/05_bdiv_otu_table_0.01/plots_weighted_unifrac_pc -m ../00_rawdata/metadata.tsv 

make_2d_plots.py -i 01_pick_closed_gg/06_bdiv_otu_table_0.005/weighted_unifrac_pc.txt -o 01_pick_closed_gg/06_bdiv_otu_table_0.005/plots_weighted_unifrac_pc -m ../00_rawdata/metadata.tsv 

make_2d_plots.py -i 02_pick_closed_silva/04_bdiv_otu_table/weighted_unifrac_pc.txt -o 02_pick_closed_silva/04_bdiv_otu_table/plots_weighted_unifrac_pc -m ../00_rawdata/metadata.tsv 

make_2d_plots.py -i 02_pick_closed_silva/05_bdiv_otu_table_0.01/weighted_unifrac_pc.txt -o 02_pick_closed_silva/05_bdiv_otu_table_0.01/plots_weighted_unifrac_pc -m ../00_rawdata/metadata.tsv 

make_2d_plots.py -i 02_pick_closed_silva/06_bdiv_otu_table_0.005/weighted_unifrac_pc.txt -o 02_pick_closed_silva/06_bdiv_otu_table_0.005/plots_weighted_unifrac_pc -m ../00_rawdata/metadata.tsv 

compare_categories.py -i 01_pick_closed_gg/04_bdiv_otu_table/weighted_unifrac_dm.txt -o 01_pick_closed_gg/04_bdiv_otu_table/plots_weighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 01_pick_closed_gg/05_bdiv_otu_table_0.01/weighted_unifrac_dm.txt -o 01_pick_closed_gg/05_bdiv_otu_table_0.01/plots_weighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 01_pick_closed_gg/06_bdiv_otu_table_0.005/weighted_unifrac_dm.txt -o 01_pick_closed_gg/06_bdiv_otu_table_0.005/plots_weighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim

compare_categories.py -i 02_pick_closed_silva/04_bdiv_otu_table/weighted_unifrac_dm.txt -o 02_pick_closed_silva/04_bdiv_otu_table/plots_weighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 02_pick_closed_silva/05_bdiv_otu_table_0.01/weighted_unifrac_dm.txt -o 02_pick_closed_silva/05_bdiv_otu_table_0.01/plots_weighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 02_pick_closed_silva/06_bdiv_otu_table_0.005/weighted_unifrac_dm.txt -o 02_pick_closed_silva/06_bdiv_otu_table_0.005/plots_weighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim

compare_categories.py -i 01_pick_closed_gg/04_bdiv_otu_table/unweighted_unifrac_dm.txt -o 01_pick_closed_gg/04_bdiv_otu_table/plots_unweighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 01_pick_closed_gg/05_bdiv_otu_table_0.01/unweighted_unifrac_dm.txt -o 01_pick_closed_gg/05_bdiv_otu_table_0.01/plots_unweighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 01_pick_closed_gg/06_bdiv_otu_table_0.005/unweighted_unifrac_dm.txt -o 01_pick_closed_gg/06_bdiv_otu_table_0.005/plots_unweighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim

compare_categories.py -i 02_pick_closed_silva/04_bdiv_otu_table/unweighted_unifrac_dm.txt -o 02_pick_closed_silva/04_bdiv_otu_table/plots_unweighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 02_pick_closed_silva/05_bdiv_otu_table_0.01/unweighted_unifrac_dm.txt -o 02_pick_closed_silva/05_bdiv_otu_table_0.01/plots_unweighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim
compare_categories.py -i 02_pick_closed_silva/06_bdiv_otu_table_0.005/unweighted_unifrac_dm.txt -o 02_pick_closed_silva/06_bdiv_otu_table_0.005/plots_unweighted_unifrac_pc/anosim -m ../00_rawdata/metadata.tsv -c "Stage" --method anosim