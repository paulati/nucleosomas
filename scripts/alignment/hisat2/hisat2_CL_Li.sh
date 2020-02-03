#!/usr/bin/env bash

#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# bowtie samtools
#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

#-----------------------------------------------------------------------------
# SLURM BATCH DIRECTIVES
#-----------------------------------------------------------------------------
#SBATCH --job-name=hisat2    #(a name to ID your job in the queue)
#SBATCH --partition=CLUSTER  #(selects a predefined group of nodes)
#SBATCH --nodes=1            #(nodes on which to run my task, default 1)
#SBATCH --time=96:00:00      #(time limit, then cancels job, i.e 2 hours)
#SBATCH --cpus-per-task=8    #(CPUs I require per task, MAX 12 per node)
#SBATCH --output=hisat2_%J.out
#SBATCH --error=hisat2_%J.err
#SBATCH --mem 30G            #(RAM Memory)

#-----------------------------------------------------------------------------
# MODULES AND ENVIRONMENTS
#-----------------------------------------------------------------------------
module purge
module load gnu samtools 
conda activate hisat2

#-----------------------------------------------------------------------------
# VARIABLES
#-----------------------------------------------------------------------------

RNASEQ_DATA_BASE_PATH=/share/databases/rawdata/ingebi/rnaseq/Li_PRJNA251583
TCRUZI_CL_GENOME_BASE_PATH=/home/pbeati/proyecto_mnaseq_Tcruzi_2019/genoma/release39_tcruzi_clbrener_esmeraldo-like
TCRUZI_CL_GENOME_PATH=$TCRUZI_CL_GENOME_BASE_PATH/repeatmasker_out/TriTrypDB-39_TcruziCLBrenerEsmeraldo-like_Genome.fasta.masked

#bowtie index location
#INDEX=$TCRUZI_CL_GENOME_BASE_PATH/index/star/TriTrypDB-39_TcruziCLBrenerEsmeraldo-like_Genome_index

#Output folder
#OUT_BASE_PATH=/home/pbeati/proyecto_mnaseq_Tcruzi_2019/reads/rnaseq_li/alignment_star/

#-----------------------------------------------------------------------------
# COMMAND AND OPTIONS
#-----------------------------------------------------------------------------

hisat2-build $TCRUZI_CL_GENOME_PATH ref
hisat2 -p 16  -x ref -1 $RNASEQ_DATA_BASE_PATH/SRR1346057_1.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346058_1.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346059_1.fastq.gz -2 $RNASEQ_DATA_BASE_PATH/SRR1346057_2.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346058_2.fastq.gz,$RNASEQ_DATA_BASE_PATH/SRR1346059_2.fastq.gz | samtools view -@ 16 -bS > RNAseq_Li_PRJNA251583.bam


