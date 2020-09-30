INITFILE="PAN-1071-QCS_S1_L001_R1_001_a.fastq"
NUMCOPIES=25
TRIMNUMBER=30000000
OUTFILE=${INITFILE%.*}_dup${NUMCOPIES}_trim${TRIMNUMBER}.fastq

filestr=""

for i in $(seq 1 $NUMCOPIES)
   do 
   filestr="${str2} ${INITFILE}"

done

cat $filestr | head -n${TRIMNUMBER} > $OUTFILE