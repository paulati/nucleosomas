BAM_BASE_PATH=/home/ubuntu/tmp_disk/alignments/XL-MNase/bowtie2/
S3_BASE_PATH=s3://tcruzi-nucleosome/XL-MNase/alignments/


ALIGNMENT_FILE_NAME=H3_IP_300U_S5
BAM_FILE_NAME=$ALIGNMENT_FILE_NAME'.bam'
BW_FILE_NAME=$ALIGNMENT_FILE_NAME'.bw'

S3_BAM_FILE_PATH=$S3_BASE_PATH$BAM_FILE_NAME
S3_BW_FILE_PATH=$S3_BASE_PATH'bigwig/'$BW_FILE_NAME

CORE_COUNT=7

source activate deepTools

cd $BAM_BASE_PATH

aws s3 cp $S3_BAM_FILE_PATH ./$BAM_FILE_NAME

samtools sort -@ $CORE_COUNT -o sort_$BAM_FILE_NAME ./$BAM_FILE_NAME

samtools index -@ $CORE_COUNT -b sort_$BAM_FILE_NAME

bamCoverage -p $CORE_COUNT -b sort_$BAM_FILE_NAME -o $BW_FILE_NAME -of bigwig

aws s3 cp ./$BW_FILE_NAME $S3_BW_FILE_PATH





