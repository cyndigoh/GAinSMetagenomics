#Picard mark duplicates

#usage = qsub -v samplelist=/well/jknight/cyndi/metagenomics_data/P160597/index/hiseq.txt,inputpath=/well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/strep,outputpath=/well/jknight/cyndi/metagenomics_data/P160597/D-analysis/markduplicates/hiseq/strep /well/jknight/cyndi/scripts/markduplicates.sh

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N markduplicates
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V

FILE=${samplelist}

while read line; do
	/apps/well/java/jdk1.8.0_latest/bin/java -jar /apps/well/picard-tools/2.0.1/picard.jar MarkDuplicates \
      I=${inputpath}/${line}_sorted.bam \
      O=${outputpath}/${line}_marked_duplicates.bam \
      M=${outputpath}/${line}_metrics.txt \
      ASSUME_SORTED=true
done < ${samplelist}
