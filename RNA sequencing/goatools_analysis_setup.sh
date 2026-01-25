##Setup of GOATOOLS input: 

# Activate mamba environment
mamba activate /home/newol210/macknight_oliver/mamba_envs/goa_tools
cd /home/newol210/macknight_oliver/GOATOOLS_working_dir

# Update GOATOOLS
pip install -U goatools

# Copy eggNOG-mapper genome-wide annotations
cp ../eggnog_mapper_working_dir/braker_asterisks_removed_aa_eggnog.emapper.annotations ./

# Make study.file that contains all the DE transcript IDs (from UTM_hap1 mapping > FeatureCounts+braker.gtf > EdgeR)
cat significant_genes_none_vs_high_brakerGTF_attempt4_w_eggNOG_annotations.txt | cut -f1 > study.file

# Make a population.file that contains all the transcript IDs that got eggNOG-mapper annotations (genome-wide)
cat braker_asterisks_removed_aa_eggnog.emapper.annotations | cut -f1 > population.file

# Make an annotation.file that contains all the transcript IDs that got eggNOG-mapper annotations (genome-wide) and their GO terms
cat braker_asterisks_removed_aa_eggnog.emapper.annotations | cut -f1,10 > annotation.file

# Then make sure to replace "," with ";" so GO terms are separated by semicolons

# Then download the most up-to-date go database
wget http://current.geneontology.org/ontology/go-basic.obo

# Then run your GO enrichment analysis
find_enrichment.py study.file population.file annotation.file > goatools_output_test_1

