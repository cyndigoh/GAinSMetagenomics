#Usage: 
#LOCA="/well/jknight/cyndi"
#LOCB="${LOCA}/metagenomics_data/P160597"
#qsub -v samplelist=${LOCB}/index/pool2.txt,refgenome=${LOCA}/references/probes/probesall,pathtofile=${LOCB}/A-rawdata/pool2,outputpath=${LOCB}/B-mapped/pool2/probes ${LOCA}/scripts/stampy/test.sh

#Script to run stampy with fastq input
#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N stampy
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2
#$ -V

#this export PATH is needed for samtools
export PATH=/apps/well/samtools/0.1.19/bin:${PATH}
export PATH=/usr/local/genetics/bin:${PATH}

FILE=${samplelist}

while read line; do
  /apps/well/stampy/1.0.23-py2.7/stampy.py \
  --genome ${refgenome} \
  --hash ${refgenome} \
  --threads 2 \
  --bamkeepgoodreads \
  --substitutionrate=0.01 \
  --map ${pathtofile}/${line}_1.fastq.gz,${pathtofile}/${line}_2.fastq.gz \
  --gapopen 40 \
  --gapextend 40 \
  --bamsortmem 200000000 \
  --inputformat fastq \
  --outputformat sam \
  --output ${outputpath}/${line}.sam \
  --overwrite
done < ${samplelist}
