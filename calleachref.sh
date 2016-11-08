#calleachref.sh calls eachref.sh
#Usage:
#qsub -v samplelist=/well/jknight/cyndi/metagenomics_data/P160597/index/pool1.txt,reference=/well/jknight/cyndi/references/probes/probeslist.txt,inputpath=/well/jknight/cyndi/metagenomics_data/P160597/B-mapped/pool1/probes,outputpath=/well/jknight/cyndi/metagenomics_data/P160597/D-analysis/mappedreads/pool1 /well/jknight/cyndi/scripts/samtools/calleachref1.sh

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N calleachref1
#$ -e /well/jknight/cyndi/qsub_logs
#$ -o /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V


FILE=${samplelist}
while read line; do
        /well/jknight/cyndi/scripts/samtools/eachref.sh ${reference} ${inputpath}/${line}_sorted.bam > ${outputpath}/${line}.tsv
done < ${samplelist}

#eachref.sh
#Number of mapped reads to each reference in multi-fasta file

reflist=$1
inbamfile=$2

printf "reference\tmappedreads\n"
FILE=${reflist}

while read line; do
  mapped=`samtools view -c -F4 ${inbamfile} ${line}`
  printf "${line}\t${mapped}\n"
done < ${reflist}
