LOCAL_DATA_BASE_PATH=/home/ubuntu/tmp_disk
S3_DATA_BASE_PATH=s3://tcruzi-nucleosome
CORE_COUNT=7
GENOME_INDEX_FILE_NAME=bowtie2_index.zip
S3_READS_R1_FILE_NAME=H3_IN_300U_S1_R1_001.fastq.gz
S3_READS_R2_FILE_NAME=H3_IN_300U_S1_R2_001.fastq.gz

#---------------------------------------------------------------------------------------------

S3_BAM_BASE_PATH=$S3_DATA_BASE_PATH/XL-MNase/alignments
LOCAL_GENOME_INDEX_BASE_PATH=$LOCAL_DATA_BASE_PATH/genome/index/bowtie2
LOCAL_READS_BASE_PATH=$LOCAL_DATA_BASE_PATH/reads/XL-MNase
LOCAL_ALIGNMENTS_BASE_PATH=$LOCAL_DATA_BASE_PATH/alignments/XL-MNase/bowtie2

S3_GENOME_INDEX_BASE_PATH=$S3_DATA_BASE_PATH/genome/index
S3_READS_BASE_PATH=$S3_DATA_BASE_PATH/XL-MNase/reads

S3_GENOME_INDEX_FILE_PATH=$S3_GENOME_INDEX_BASE_PATH/$GENOME_INDEX_FILE_NAME
LOCAL_GENOME_INDEX_FILE_PATH=$LOCAL_GENOME_INDEX_BASE_PATH/$GENOME_INDEX_FILE_NAME

#bowtie index location
INDEX=$LOCAL_DATA_BASE_PATH/genome/index/bowtie2/TriTrypDB-46_TcruziCLBrenerEsmeraldo-like_Genome_index

#Output folder
OUT_BASE_PATH=$LOCAL_ALIGNMENTS_BASE_PATH

#---------------------------------------------------------------------------------------------

# copy index from s3 to local:
#aws s3 cp $S3_GENOME_INDEX_FILE_PATH $LOCAL_GENOME_INDEX_BASE_PATH
#unzip $LOCAL_GENOME_INDEX_FILE_PATH -d $LOCAL_GENOME_INDEX_BASE_PATH

#copy fastq data from s3 to local:
#aws s3 cp $S3_READS_BASE_PATH/$S3_READS_R1_FILE_NAME $LOCAL_READS_BASE_PATH
#aws s3 cp $S3_READS_BASE_PATH/$S3_READS_R2_FILE_NAME $LOCAL_READS_BASE_PATH

#---------------------------------------------------------------------------------------------

cd $LOCAL_READS_BASE_PATH

source activate bowtie2

for file in *_R1_001.fastq.gz;
do

	echo $file
	#file="SRR1346057_1.fastq.gz"

	file=${file##*/}

	exp_name="${file:0:${#file}-16}"

	fastq1=$LOCAL_READS_BASE_PATH/$S3_READS_R1_FILE_NAME
	fastq2=$LOCAL_READS_BASE_PATH/$S3_READS_R2_FILE_NAME

	sam_file_path=$OUT_BASE_PATH/$exp_name.sam
	bam_file_path=$OUT_BASE_PATH/$exp_name.bam

	met_file_path=$OUT_BASE_PATH/$exp_name.met


	printf "\nProcessing files: ${exp_name}_R1_001.fastq.gz and ${exp_name}_R2_001.fastq.gz \n"
	printf "1) Aligning the reads (creating the SAM file)... \n" ;
	
	echo $fastq1 
	echo $fastq2
	echo $out_file_name

	bowtie2 -p $CORE_COUNT --met-file $met_file_path -x $INDEX -1 $fastq1 -2 $fastq2 -S $sam_file_path

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





