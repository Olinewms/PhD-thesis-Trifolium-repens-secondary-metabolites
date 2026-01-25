from Bio import SeqIO

# Paths to input/output files
fasta_file = "/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/stringtie_gtf/UTMhap1_stringtieMerged17GTFs_transcripts_updatedHeaders.fasta"
map_file = "/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/stringtie_gtf/gene_transcript_map.txt"
output_file = "/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/stringtie_gtf/UTMhap1_stringtieMerged17GTFs_transcripts_updatedHeaders_geneIDs.fasta"

# Read the gene-transcript map into a dictionary
gene_transcript_map = {}
with open(map_file, "r") as map_fh:
    for line in map_fh:
        gene_id, transcript_id = line.strip().split()
        gene_transcript_map[transcript_id] = gene_id

# Process the FASTA file and replace transcript IDs with gene IDs
with open(fasta_file, "r") as fasta_fh, open(output_file, "w") as output_fh:
    for record in SeqIO.parse(fasta_fh, "fasta"):
        original_id = record.id
        if original_id in gene_transcript_map:
            record.id = gene_transcript_map[original_id]
            record.description = ""  # Clear description for cleaner FASTA
        SeqIO.write(record, output_fh, "fasta")

print(f"Updated FASTA saved to {output_file}")
