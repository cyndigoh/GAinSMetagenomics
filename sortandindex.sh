#Usage:
#qsub -v samplelist=/well/jknight/cyndi/metagenomics_data/P160597/index/pool2.txt,path=/well/jknight/cyndi/metagenomics_data/P160597/B-mapped/pool2/probes /well/jknight/cyndi/scripts/samtools/sortandindex.sh

#Generate sorted and indexed bam files (from sam file)

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N sortandindex
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V

FILE=${samplelist}

while read line; do
  samtools view -u -S ${path}/${line}.sam | samtools sort - ${path}/${line}_sorted
  samtools index ${path}/${line}_sorted.bam
done < ${samplelist}

#sortandindexmarkdup.sh
#as for sortandindex.sh but for bams with duplicates marked
#Usage:
#qsub -v samplelist=/well/jknight/cyndi/metagenomics_data/P160597/index/pool2.txt,path=/well/jknight/cyndi/metagenomics_data/P160597/B-mapped/pool2/flu_strep/markedduplicates /well/jknight/cyndi/scripts/samtools/sortandindexmarkdup.sh

#Generate sorted and indexed bam files (from sam file)

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N sortandindexmarkdup
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V

FILE=${samplelist}

while read line; do
  samtools sort ${path}/${line}_marked_duplicates.bam ${path}/${line}_marked_duplicates_sorted
  samtools index ${path}/${line}_marked_duplicates_sorted.bam
done < ${samplelist}
