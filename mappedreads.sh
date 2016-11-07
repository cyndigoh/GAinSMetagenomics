#Usage:
#qsub -v samplelist=/well/jknight/cyndi/metagenomics_data/P160597/index/pool2.txt,path=/well/jknight/cyndi/metagenomics_data/P160597/B-mapped/pool2/probes /well/jknight/cyndi/scripts/samtools/mappedreads.sh > /well/jknight/cyndi/metagenomics_data/P160597/D-analysis/mappedreads/pool2.tsv

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N mappedreads
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V

printf "sampleindex\ttotalreads\tmappedreads\tunmappedreads\n"
FILE=${samplelist}
while read line; 
	totalreads=`samtools view -c ${path}/${line}_sorted.bam`
	mappedreads=`samtools view -F4 -c ${path}/${line}_sorted.bam`
	unmappedreads=`samtools view -f4 -c ${path}/${line}_sorted.bam`
	printf "${line}\t${totalreads}\t${mappedreads}\t${unmappedreads}\n"
done < ${samplelist}
