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

#noduplicates.sh - counts the number of reads mapping to a reference which are NOT duplicates
#Usage:
#qsub -o /well/jknight/cyndi/metagenomics_data/P160597/D-analysis/markduplicates/hiseq/strep/summary.tsv -v samplelist=/well/jknight/cyndi/metagenomics_data/P160597/index/hiseq.txt,path=/well/jknight/cyndi/metagenomics_data/P160597/D-analysis/markduplicates/hiseq/strep /well/jknight/cyndi/scripts/samtools/noduplicates.sh 

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N noduplicates
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V

printf "sampleindex\ttotalreads\ttotalmapped\tmappednotduplicate\n"
FILE=${samplelist}
while read line; do
        totalreads=`samtools view -c ${path}/${line}_marked_duplicates.bam`
        totalmapped=`samtools view -F4 -c ${path}/${line}_marked_duplicates.bam`
        mappednotduplicate=`samtools view -F1028 -c ${path}/${line}_marked_duplicates.bam`
        printf "${line}\t${totalreads}\t${totalmapped}\t${mappednotduplicate}\n"
done < ${samplelist}
