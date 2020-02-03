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


STAR --runThreadN 8 --runMode genomeGenerate --genomeDir $INDEX --genomeFastaFiles $TCRUZI_CL_GENOME_PATH --genomeSAindexNbases 11



