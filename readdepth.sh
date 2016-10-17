#SCRIPT 1: runreaddepth.sh (Use this for running readdepth.sh)

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N runreaddepth.sh
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2

FILE=/well/jknight/cyndi/metagenomics_data/P160597/C-scripts/samplelistall.txt

while read line; do
	/well/jknight/cyndi/metagenomics_data/P160597/B-mapped/hiseq/strep/WTCHG_316348_${line}_sorted.bam \
	/well/jknight/cyndi/references/strep_pneumo/strep_pneumo.fasta "gi|220673408|emb|FM211187.1|" \
	/well/jknight/cyndi/metagenomics_data/P160597/D-analysis/readdepth/${line}readdepth.tsv
        

done < /well/jknight/cyndi/metagenomics_data/P160597/C-scripts/samplelistall.txt

#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N runreaddepth.sh
#$ -o /well/jknight/cyndi/metagenomics_data/P160016/qsub_logs
#$ -e /well/jknight/cyndi/metagenomics_data/P160016/qsub_logs
#$ -pe shmem 2

FILE=/well/jknight/cyndi/scripts/samplelist.txt

while read line; do
	/well/jknight/cyndi/scripts/readdepth.sh /well/jknight/cyndi/metagenomics_data/P160016/data/bwamapped/WTCHG_247272_${line}_sorted.bam \
	/well/jknight/cyndi/metagenomics_data/P160016/reference_genomes/HCV_closest_refs/1a_HQ850279short.fasta 1a_HQ850279 \
	/well/jknight/cyndi/metagenomics_data/P160016/analysis/readdepth/${line}.tsv

done < /well/jknight/cyndi/scripts/samplelist.txt

#SCRIPT 2: readdepth.sh
#!/usr/bin/env bash

if [ $# -lt 4 ] ; then
    echo "Usage: onesampledepth.sh inbam refpath refid outtable"
    exit 1
fi
inbam=$1
refpath=$2
refid=$3
outtable=$4

# intermediate files
tmpsam1=`echo ${inbam} | sed "s,.bam,.tmp1.sam,g"`
tmpsam2=`echo ${inbam} | sed "s,.bam,.tmp2.sam,g"`
tmpbam=`echo ${inbam} | sed "s,.bam,.tmp.bam,g"`

# This next part of the script wouldn't work as there were issues using awk to extract reads that were mapping to the relevant HCV ref as both primary and secondary alignment (columns 3 and 7)
# Python script filtersam.py has been used to bypass this part 
# Use samtools view and grep to extract a BAM file that contains only the header and the HCV records

#echo "samtools view -H ${inbam} > ${tmpsam}"
#      samtools view -H ${inbam} > ${tmpsam}
#if [ $? -ne 0 ] ; then
#     echo "Failed: samtools view -H ${inbam} > ${tmpsam}"
#     exit 2
#fi

#echo "samtools view ${inbam} | grep ${refid} >> ${tmpsam}"
#      samtools view ${inbam} | grep ${refid} >> ${tmpsam}
#if [ $? -ne 0 ] ; then
#     echo "Failed: samtools view ${inbam} | grep ${refid} >> ${tmpsam}"
#     exit 3
#fi

#echo "samtools view ${inbam} | awk '$3==\"${refid}\" && ($7==\"${refid}\"||$7=="=")' >> ${tmpsam}"
#awk 'BEGIN {print "'"$variable"'"}'
#      samtools view ${inbam} | awk -v variable=$refid} '$3==$variable && ($7==$variable||$7=="=")' >> ${tmpsam}
#if [ $? -ne 0 ] ; then
#    echo "Failed: "
#    exit 3
#fi

echo "samtools view -h ${inbam} > ${tmpsam1}"
      samtools view -h ${inbam} > ${tmpsam1}
if [ $? -ne 0 ] ; then
    echo "Failed: samtools view -h ${inbam} > ${tmpsam1}"
    exit 2

echo "./filtersam.py ${tmpsam1} ${refid} ${tmpsam2}"
      ./filtersam.py ${tmpsam1} ${refid} ${tmpsam2}
if [ $? -ne 0 ] ; then
    echo "Failed: ./filtersam.py ${tmpsam1} ${refid} ${tmpsam2}"
    exit 3

echo "samtools view -b -S -o ${tmpbam} ${tmpsam2}"
      samtools view -b -S -o ${tmpbam} ${tmpsam2}
if [ $? -ne 0 ] ; then
     echo "Failed: samtools view -b -S -o ${tmpbam} ${tmpsam2}"
     exit 4
fi

# Use bamdepth to get a tsv file of depths (including the zero ones)
exptid=`basename ${inbam} | sed "s,.bam,,g"`
echo "/well/bsg/microbial/mgtools/bamdepth.py ${tmpbam} ${refpath} ${exptid} 1 1 1 0 ${outtable}"
      /well/bsg/microbial/mgtools/bamdepth.py ${tmpbam} ${refpath} ${exptid} 1 1 1 0 ${outtable}
if [ $? -ne 0 ] ; then
     echo "Failed: /well/bsg/microbial/mgtools/bamdepth.py ${tmpbam} ${refpath} ${exptid} 1 1 1 0 ${outtable}"
     exit 5
fi

# Might need to use sed to make sure the tsv file you end up with contains columns:
# samplename, libraryprep, ref, pos, readdepth

#SCRIPT 3: filtersam.py (automatically called from readdepth.sh)
#This script extracts the reads mapped to the HCV ref as primary alignment (column 3) with no secondary alignment (ie column 7 is a zero)
#!/usr/bin/env python

import os
import sys

if len(sys.argv) < 4:
    print('filtersam.py insam contigid outsam')
    sys.exit(1)
insam = sys.argv[1]
contigid = sys.argv[2]
outsam = sys.argv[3]

with open(outsam, 'w') as out_fp:
    with open(insam, 'r') as in_fp:
        for line in in_fp:
            if line.startswith('@'):
                out_fp.write(line)
            else:
                L = line.rstrip('\n').split('\t')
                if L[2] == contigid and (L[6] == '=' or L[6] == contigid):
                    out_fp.write(line)
