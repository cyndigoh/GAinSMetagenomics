#Script to run Stampy with fastq input
#usage: ./stampy.sh samplelist.txt /well/jknight/cyndi/references/probes/probesall /well/jknight/cyndi/metagenomics_data/P160597/A-rawdata/pool2 /well/jknight/cyndi/metagenomics_data/P160597/B-mapped/pool2/probes
#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N stampy
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2

# Defining the arguments
samplelist=$1
refgenome=$2
pathtofile=$3
outputpath=$4

# this export PATH is needed for samtools
export PATH=/apps/well/samtools/0.1.19/bin:${PATH}
export PATH=/usr/local/genetics/bin:${PATH}

source ~/.bashrc
sh /apps/well/profile.d/python/2.7.sh

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
