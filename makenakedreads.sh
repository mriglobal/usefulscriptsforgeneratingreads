targetgenomefiles=($(ls ../orggenomes/*.fa))
titerlvls="5 50 500 5000 50000"
readtype=0
matereadtype=2
R1errorprofile="0.001-0.01"
R2errorprofile="0.001-0.01"
maxreadpairdistance=500
stdreadpairdistance=10
R1length=75
R2length=75
maxNallowed=0
numreads=1000000

for ((i=0; i<${#targetgenomefiles[@]};i++));
  do
  name=$(basename ${targetgenomefiles[$i]} .fa);
  echo ${targetgenomefiles[$i]} 
  dwgsim -c ${readtype} -S ${matereadtype} -e ${R1errorprofile} -E ${R2errorprofile} -d ${maxreadpairdistance} -s ${stdreadpairdistance} -1 ${R1length} -2 ${R2length} -n ${maxNallowed} -N ${numreads} ${targetgenomefiles[$i]} ${name};
  for titlvl in $titerlvls;

    do
    echo ${targetgenomefiles[$i]} ${name}_${titlvl}.fastq
    head -n  $(( 4 * ${titlvl})) ${name}.bwa.read1.fastq > ${name}_${titlvl}_R1.fastq
    head -n  $(( 4 * ${titlvl})) ${name}.bwa.read2.fastq > ${name}_${titlvl}_R2.fastq

  done
done
