#LOCAL_DATA_BASE_PATH=/home/ubuntu/tmp_disk
LOCAL_DATA_BASE_PATH=/home/ubuntu/disco_tmp
S3_DATA_BASE_PATH=s3://tcruzi-nucleosome
CORE_COUNT=7
GENOME_INDEX_FILE_NAME=bowtie2_index.zip
S3_READS_R1_FILE_NAME=CLJ_1_70U_comb_R1.fastq.gz 
S3_READS_R2_FILE_NAME=CLJ_1_70U_comb_R2.fastq.gz 

#---------------------------------------------------------------------------------------------

S3_BAM_BASE_PATH=$S3_DATA_BASE_PATH/MNase/alignments
LOCAL_GENOME_INDEX_BASE_PATH=$LOCAL_DATA_BASE_PATH/genome/index/bowtie2
LOCAL_READS_BASE_PATH=$LOCAL_DATA_BASE_PATH/reads/MNase/clean
LOCAL_ALIGNMENTS_BASE_PATH=$LOCAL_DATA_BASE_PATH/alignments/MNase/bowtie2

S3_GENOME_INDEX_BASE_PATH=$S3_DATA_BASE_PATH/genome/index
S3_READS_BASE_PATH=$S3_DATA_BASE_PATH/MNase/reads/clean

S3_GENOME_INDEX_FILE_PATH=$S3_GENOME_INDEX_BASE_PATH/$GENOME_INDEX_FILE_NAME
LOCAL_GENOME_INDEX_FILE_PATH=$LOCAL_GENOME_INDEX_BASE_PATH/$GENOME_INDEX_FILE_NAME

#bowtie index location
INDEX=$LOCAL_DATA_BASE_PATH/genome/release46_tcruzi_clbrener_all/index/bowtie/TriTrypDB-46_TcruziCLBrenerAll_Genome_index

#Output folder
OUT_BASE_PATH=$LOCAL_ALIGNMENTS_BASE_PATH

#---------------------------------------------------------------------------------------------

echo $S3_READS_BASE_PATH/$S3_READS_R1_FILE_NAME
echo $LOCAL_READS_BASE_PATH/$S3_READS_R1_FILE_NAME
echo $S3_READS_BASE_PATH/$S3_READS_R2_FILE_NAME
echo $LOCAL_READS_BASE_PATH/$S3_READS_R2_FILE_NAME

# copy index from s3 to local:
# aws s3 cp $S3_GENOME_INDEX_FILE_PATH $LOCAL_GENOME_INDEX_BASE_PATH
# unzip $LOCAL_GENOME_INDEX_FILE_PATH -d $LOCAL_GENOME_INDEX_BASE_PATH

#copy fastq data from s3 to local:
#aws s3 cp $S3_READS_BASE_PATH/$S3_READS_R1_FILE_NAME $LOCAL_READS_BASE_PATH/$S3_READS_R1_FILE_NAME
#aws s3 cp $S3_READS_BASE_PATH/$S3_READS_R2_FILE_NAME $LOCAL_READS_BASE_PATH/$S3_READS_R2_FILE_NAME

#---------------------------------------------------------------------------------------------

cd $LOCAL_READS_BASE_PATH

source activate bowtie2

#for file in *_R1_001.fastq.gz;
for file in *_R1.fastq.gz;
do

	echo $file

	file=${file##*/}

	exp_name="${file:0:${#file}-17}"

	fastq1=$LOCAL_READS_BASE_PATH/$S3_READS_R1_FILE_NAME
	fastq2=$LOCAL_READS_BASE_PATH/$S3_READS_R2_FILE_NAME

	sam_file_path=$OUT_BASE_PATH/$exp_name.sam
	bam_file_path=$OUT_BASE_PATH/$exp_name.bam

	met_file_path=$OUT_BASE_PATH/$exp_name.met

	bowtie2_output_file_path=$OUT_BASE_PATH/$exp_name'_output.txt'
	bowtie2_summary_file_path=$OUT_BASE_PATH/$exp_name'_summary.txt'

	printf "\nProcessing files: $fastq1 and $fastq2 \n"
	printf "1) Aligning the reads (creating the SAM file)... \n" ;
	
	echo $fastq1 
	echo $fastq2
	echo $out_file_name

	bowtie2 -X 1000 --very-sensitive --no-discordant --no-mixed --no-unal \
		-p $CORE_COUNT -x $INDEX -1 $fastq1 -2 $fastq2 -S $sam_file_path > $bowtie2_output_file_path 2> $bowtie2_summary_file_path

	# bowtie2 -p $CORE_COUNT -x $INDEX -1 $fastq1 -2 $fastq2 -S $sam_file_path > $bowtie2_output_file_path 2> $bowtie2_summary_file_path

	samtools view -Sb $sam_file_path  >  $bam_file_path

	aws s3 cp $bam_file_path $S3_BAM_BASE_PATH/$exp_name.bam

	#delete local files:
	# rm $fastq1
	# rm $fastq2

	#delete sam file:
	# rm $sam_file_path

	#delete bam file
	# rm $bam_file_path

done





