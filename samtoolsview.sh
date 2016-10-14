#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N samtoolsview
#$ -o /well/jknight/cyndi/metagenomics_data/qsub_logs
#$ -e /well/jknight/cyndi/metagenomics_data/qsub_logs
#$ -pe shmem 2

# this export PATH is needed for samtools
export PATH=/apps/well/samtools/0.1.19/bin:${PATH}
export PATH=/usr/local/genetics/bin:${PATH}

FILE=/well/jknight/cyndi/metagenomics_data/P160597/C-scripts/pool2.txt

while read line; do
        echo ${line}
        echo "total number of reads"
        samtools view -c /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/strep/WTCHG_316348_${line}_sorted.bam
        echo "mapped"
        samtools view -F4 -c /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/strep/WTCHG_316348_${line}_sorted.bam
        echo "unmapped"
        samtools view -f4 -c /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/strep/WTCHG_316348_${line}_sorted.bam
done < /well/jknight/cyndi/metagenomics_data/P160597/C-scripts/pool2.txt
