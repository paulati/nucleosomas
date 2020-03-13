
quality()
{
	FILE1_NAME=$1
	FILE2_NAME=$2

	LOCAL_READS_BASE_PATH=/home/ubuntu/tmp_disk/reads/XL-MNase/raw
	S3_READS_BASE_PATH=s3://tcruzi-nucleosome/XL-MNase/reads/replicate1

	cd ~/soft/FastQC
	aws s3 cp $S3_READS_BASE_PATH/$FILE1_NAME $LOCAL_READS_BASE_PATH
	aws s3 cp $S3_READS_BASE_PATH/$FILE2_NAME $LOCAL_READS_BASE_PATH

	echo $(zcat $LOCAL_READS_BASE_PATH/$FILE1_NAME | wc -l) / 4 | bc
	echo $(zcat $LOCAL_READS_BASE_PATH/$FILE2_NAME | wc -l) / 4 | bc
	echo $(md5sum $LOCAL_READS_BASE_PATH/$FILE1_NAME)
	echo $(md5sum $LOCAL_READS_BASE_PATH/$FILE2_NAME)

	rm $LOCAL_READS_BASE_PATH/$FILE1_NAME
	rm $LOCAL_READS_BASE_PATH/$FILE2_NAME
}


files_head="H3_IN_300U_S1_R H3_IP_300U_S5_R IN_neg_2_400U_S4_R IP_neg_2_400U_S8_R Me1_IN_200U_S3_R Me1_IP_200U_S7_R Me2_IN_350U_S2_R Me2_IP_350U_S6_R"
# files_head="H3_IN_300U_S1_R"
#files_head="H3_IP_300U_S5_R"


for file_head in $files_head; do
    FILE1_NAME=$file_head'1_001.fastq.gz'
    FILE2_NAME=$file_head'2_001.fastq.gz'
	echo $FILE1_NAME
	echo $FILE2_NAME
	quality $FILE1_NAME $FILE2_NAME
done


