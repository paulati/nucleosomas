#!/usr/bin/env bash

#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# bowtie samtools
#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

#-----------------------------------------------------------------------------
# SLURM BATCH DIRECTIVES
#-----------------------------------------------------------------------------
#SBATCH --job-name=star    #(a name to ID your job in the queue)
#SBATCH --partition=CLUSTER  #(selects a predefined group of nodes)
#SBATCH --nodes=1            #(nodes on which to run my task, default 1)
#SBATCH --time=96:00:00      #(time limit, then cancels job, i.e 2 hours)
#SBATCH --cpus-per-task=8    #(CPUs I require per task, MAX 12 per node)
#SBATCH --output=slurm_%J.out
#SBATCH --error=slurm_%J.err
#SBATCH --mem 30G            #(RAM Memory)

#-----------------------------------------------------------------------------
# MODULES AND ENVIRONMENTS
#-----------------------------------------------------------------------------
#module purge
#module load gnu samtools bowtie2
source activate star

#-----------------------------------------------------------------------------
# VARIABLES
#-----------------------------------------------------------------------------

RNASEQ_DATA_BASE_PATH=/share/databases/rawdata/ingebi/rnaseq/Li_PRJNA251583
TCRUZI_CL_GENOME_BASE_PATH=/home/pbeati/proyecto_mnaseq_Tcruzi_2019/genoma/release46_tcruzi_clbrener_esmeraldo-like
TCRUZI_CL_GENOME_PATH=$TCRUZI_CL_GENOME_BASE_PATH/TriTrypDB-46_TcruziCLBrenerEsmeraldo-like_Genome.fasta

#star index location
INDEX=$TCRUZI_CL_GENOME_BASE_PATH/index/star

#Output folder
OUT_BASE_PATH=/home/pbeati/proyecto_mnaseq_Tcruzi_2019/alineamientos/2020/star/

#-----------------------------------------------------------------------------
# COMMAND AND OPTIONS
#-----------------------------------------------------------------------------

cd $RNASEQ_DATA_BASE_PATH

for file in *_1.fastq.gz;
do

	#file="SRR1346057_1.fastq.gz"

	file=${file##*/}
	exp_name="${file:0:${#file}-11}"

	out_file_name=$OUT_BASE_PATH$exp_name
	fastq1=$RNASEQ_DATA_BASE_PATH/$exp_name"_1.fastq.gz"
	fastq2=$RNASEQ_DATA_BASE_PATH/$exp_name"_2.fastq.gz"

	printf "\nProcessing files: ${exp_name}_1.fastq.gz and ${exp_name}_2.fastq.gz \n"
	printf "1) Aligning the reads (creating the SAM file)... \n" ;
	
	STAR --runThreadN 8 --readFilesCommand zcat --genomeDir $INDEX --readFilesIn $fastq1 $fastq2 --outFileNamePrefix $out_file_name

done



# STAR --runThreadN 8 --runMode genomeGenerate --genomeDir $INDEX --genomeFastaFiles $TCRUZI_CL_GENOME_PATH --genomeSAindexNbases 11
# STAR --runThreadN 8 --genomeDir $INDEX --readFilesCommand zcat --readFilesIn $RNASEQ_DATA_BASE_PATH/SRR1346057_1.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346058_1.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346059_1.fastq.gz $RNASEQ_DATA_BASE_PATH/SRR1346057_2.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346058_2.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346059_2.fastq.gz

# samtools view -@ 16 -bS Aligned.out.sam > RNAseq_Li_PRJNA251583.bam


