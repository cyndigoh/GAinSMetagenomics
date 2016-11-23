bwa.sh
#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N bwa
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2

# this export PATH is needed for samtools
export PATH=/apps/well/samtools/0.1.19/bin:${PATH}
export PATH=/usr/local/genetics/bin:${PATH}

#list of sample index names
FILE=/well/jknight/cyndi/metagenomics_data/P160597/index/hiseq.txt

while read tag; do
  #map with bwa
  /apps/well/bwa/0.7.12/bwa mem -M -t 2 /well/jknight/cyndi/references/GRCh38/GCA_000001405.15_GRCh38_full_analysis_set.fna /well/jknight/cyndi/metagenomics_data/P160597/A-rawdata/hiseq/fastq/${tag}_1.fastq.gz /well/jknight/cyndi/metagenomics_data/P160597/A-rawdata/hiseq/fastq/${tag}_2.fastq.gz > /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/GRCh38/${tag}.sam

  #Sort and index
  samtools view -u -S /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/GRCh38/${tag}.sam | samtools sort - /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/GRCh38/${tag}_sorted
  samtools index /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/GRCh38/${tag}_sorted.bam

done < /well/jknight/cyndi/metagenomics_data/P160597/index/hiseq.txt
