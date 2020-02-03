#!/usr/bin/env bash

#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# bowtie samtools
#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

#-----------------------------------------------------------------------------
# SLURM BATCH DIRECTIVES
#-----------------------------------------------------------------------------
#SBATCH --job-name=bowtie2    #(a name to ID your job in the queue)
#SBATCH --partition=CLUSTER  #(selects a predefined group of nodes)
#SBATCH --nodes=1            #(nodes on which to run my task, default 1)
#SBATCH --time=96:00:00      #(time limit, then cancels job, i.e 2 hours)
#SBATCH --cpus-per-task=4    #(CPUs I require per task, MAX 12 per node)
#SBATCH --output=slurm_%J.out
#SBATCH --error=slurm_%J.err
#SBATCH --mem 30G            #(RAM Memory)

#-----------------------------------------------------------------------------
# MODULES AND ENVIRONMENTS
#-----------------------------------------------------------------------------
module purge
module load gnu samtools bowtie2

#-----------------------------------------------------------------------------
# VARIABLES
#-----------------------------------------------------------------------------

RNASEQ_DATA_BASE_PATH=/share/databases/rawdata/ingebi/rnaseq/Li_PRJNA251583
TCRUZI_CL_GENOME_BASE_PATH=/home/pbeati/proyecto_mnaseq_Tcruzi_2019/genoma/release39_tcruzi_clbrener_esmeraldo-like

#bowtie index location
INDEX=$TCRUZI_CL_GENOME_BASE_PATH/index/repeatmasker_out/TriTrypDB-39_TcruziCLBrenerEsmeraldo-like_Genome_index

#Output folder
OUT_BASE_PATH=$RNASEQ_DATA_BASE_PATH/alignment/


#-----------------------------------------------------------------------------
# COMMAND AND OPTIONS
#-----------------------------------------------------------------------------
cd $RNASEQ_DATA_BASE_PATH

for file in *_1.fastq.gz;
do

	#file="SRR1346057_1.fastq.gz"

	file=${file##*/}
	exp_name="${file:0:${#file}-11}"

	out_file_name=$OUT$exp_name.sam
	fastq1=$RNASEQ_DATA_BASE_PATH/$exp_name"_1.fastq.gz"
	fastq2=$RNASEQ_DATA_BASE_PATH/$exp_name"_2.fastq.gz"

	printf "\nProcessing files: ${exp_name}_1.fastq.gz and ${exp_name}_2.fastq.gz \n"
	printf "1) Aligning the reads (creating the SAM file)... \n" ;
	
#	bowtie2 -x $INDEX -1 $fastq1 -2 $fastq2 -S $out_file_name
	bowtie2 -p 4 -I 100 -X 400 -x $INDEX --fr -1 $fastq1 -2 $fastq2 -S $out_file_name

done

