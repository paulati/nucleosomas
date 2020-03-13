#!/usr/bin/env bash

#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
# bowtie samtools
#<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

#-----------------------------------------------------------------------------
# SLURM BATCH DIRECTIVES
#-----------------------------------------------------------------------------
#SBATCH --job-name=bowtie2_index    #(a name to ID your job in the queue)
#SBATCH --partition=CLUSTER  #(selects a predefined group of nodes)
#SBATCH --nodes=1            #(nodes on which to run my task, default 1)
#SBATCH --time=02:00:00      #(time limit, then cancels job, i.e 2 hours)
#SBATCH --cpus-per-task=2    #(CPUs I require per task, MAX 12 per node)
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

#Fastq location
GENOME_DATA_FILE=/paula/2020/josefina/amazon_ubuntu/tmp_disk/genome/release46_tcruzi_clbrener_all/TriTrypDB-46_TcruziCLBrenerAll_Genome.fasta

#Output file
OUT=/paula/2020/josefina/amazon_ubuntu/tmp_disk/genome/release46_tcruzi_clbrener_all/index/bowtie/TriTrypDB-46_TcruziCLBrenerAll_Genome_index


#-----------------------------------------------------------------------------
# COMMAND AND OPTIONS
#-----------------------------------------------------------------------------

bowtie2-build $GENOME_DATA_FILE $OUT
