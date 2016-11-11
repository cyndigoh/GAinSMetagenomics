#countsbymapq.sh - counts mapped reads which are not duplicates and above a mapq threshold
#Usage:
#qsub -o /well/jknight/cyndi/metagenomics_data/P160597/D-analysis/markduplicates/hiseq/strep/mapq30.tsv -v samplelist=/well/jknight/cyndi/metagenomics_data/P160597/index/hiseq.txt,threshold=30,path=/well/jknight/cyndi/metagenomics_data/P160597/D-analysis/markduplicates/hiseq/strep /well/jknight/cyndi/scripts/samtools/countsbymapq.sh       

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N countsbymapq
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V

printf "sampleindex\ttotalreads\ttotalmapped\tmappednotduplicate\tmappedgoodquality\n"
FILE=${samplelist}
while read line; do
        totalreads=`samtools view -c ${path}/${line}_marked_duplicates.bam`
        totalmapped=`samtools view -F4 -c ${path}/${line}_marked_duplicates.bam`
        mappednotduplicate=`samtools view -F1028 -c ${path}/${line}_marked_duplicates.bam`
        mappedgoodquality=`samtools view -c -F1028 -q ${threshold} ${path}/${line}_marked_duplicates.bam`

        printf "${line}\t${totalreads}\t${totalmapped}\t${mappednotduplicate}\t${mappedgoodquality}\n"
done < ${samplelist}
