#krona.sh
#!/usr/bin/env bash
#$ -cwd
#$ -q short.qc
#$ -P jknight.prjc
#$ -N krona
#$ -o /well/jknight/cyndi/qsub_logs
#$ -e /well/jknight/cyndi/qsub_logs
#$ -pe shmem 2

FILE=/well/jknight/cyndi/metagenomics_data/P160597/C-scripts/pool2.txt

while read line; do
	cut -f2,3 /well/jknight/cyndi/metagenomics_data/P160597/D-analysis/kraken/pool2/${line}.taxonomy > /well/jknight/cyndi/metagenomics_data/P160597/D-analysis/kraken/pool2/krona/${line}.in

	/apps/well/kronatools/2.6.1/bin/ktImportTaxonomy /well/jknight/cyndi/metagenomics_data/P160597/D-analysis/kraken/pool2/krona/${line}.in -o /well/jknight/cyndi/metagenomics_data/P160597/D-analysis/kraken/pool2/krona/${line}.out.html

done < /well/jknight/cyndi/metagenomics_data/P160597/C-scripts/pool2.txt
