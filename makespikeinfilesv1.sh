ifpattern="PAN-1071-QCS_S1_L001_R*_001_*.fastq"
inputfiles=($(ls $ifpattern));
targetgenomefiles=($(ls orggenomes/*.fa))
titerlvls="5 50"
workdir=intermediatefile_titerlvls

rm -rf $workdir
mkdir $workdir
cd $workdir
cp ../$ifpattern . 


for ((i=0; i<${#targetgenomefiles[@]};i++));
   do echo $i;
   #echo "start loop"
   echo #targetgenomefiles[@]
   echo ${targetgenomefiles[$i]};
   gfname=${targetgenomefiles[$i]}
   #echo $(basename ${gfname%.*})_all_reads.fastq;

   dwgsim -c 0 -S 2 -e 0.001-0.01 -E 0.001-.01 -d 500 -s 10 -1 75 -2 75 -n 0 ../${gfname} $(basename ${gfname%.*})_all_reads.fastq;

   for titlvl in $titerlvls;
       do #echo $(basename ${gfname%.*})
       #echo $(basename ${gfname%.*})*fastq.bwa.read1.fastq 
       #echo $(basename ${gfname%.*})*fastq.bwa.read2.fastq
       echo ${titlvl}" titerlvl"
       paste $(basename ${gfname%.*})*fastq.bwa.read1.fastq  $(basename ${gfname%.*})*fastq.bwa.read2.fastq |
       awk '{ printf("%s",$0); n++; if(n%4==0){printf("\n");} else { printf("\t");}}'|
       awk -v k=$titlvl 'BEGIN{srand(systime()+PROCINFO["pid"]);}{s=x++<k?x-1:int(rand()*x);if(s<k)R[s]=$0}END{for(i in R)print R[i]}'|
       awk -F"\t" -v fbname=$(basename ${gfname%.*})_${titlvl} '{print$1"\n"$3"\n"$5"\n"$7 > fbname"_R1.fastq"  ;print$2"\n"$4"\n"$6"\n"$8 > fbname"_R2.fastq" }'

   done

done

echo ${#targetgenomefiles[@]}" numgenome"

mkdir finalspikedinfiles
mkdir background_subsamples

for ((i=0; i<${#inputfiles[@]};i++));

   do #echo $i
   filename=${inputfiles[$i]}
   filenameprefix=$(echo ${filename} | sed 's/_R[12]/        /g' | cut -d' ' -f1)
   echo ${inputfiles[$i]}
   #echo ${filename%.*} $filenameprefix filename
   pn=$(echo $filename | grep -Eo "_R[[:digit:]]_" | cut -c 3 )
   #echo ${pn}" matching" 

   for titlvl in $titerlvls;
       do #echo "pass"
       #echo $(expr $titlvl \* ${#targetgenomefiles[@]} )
       #echo $(expr $(wc -l $filename | awk '{ print $1 }') - $(expr $titlvl \* ${#targetgenomefiles[@]} \* 4 )  )
       head -n $(expr $(wc -l $filename | awk '{ print $1 }') - $(expr $titlvl \* ${#targetgenomefiles[@]} \* 4 )  ) $filename  > ${filename%.*}_R${pn}_${titlvl}_backg.fastq
       #echo ${filenameprefix}*_R${pn}*_${titlvl}_backg.fastq
       flstr=${filenameprefix}*_R${pn}*_${titlvl}_backg.fastq
       echo $flstr
       for ((j=0; j<${#targetgenomefiles[@]};j++));
          do #echo "part"
          #echo ${targetgenomefiles[$j]}
          gfname=${targetgenomefiles[$j]}
          #echo $gfname
          #echo ${gfname%.*}
          #echo $(basename ${gfname%.*})
          #echo  "here"
          flstr=${flstr}" "$(basename ${gfname%.*})_${titlvl}"_R"${pn}".fastq"
       done
       echo $flstr
       wc -l $flstr
       #pwd
       #ls *fastq
       cat $flstr > finalspikedinfiles/${filename}_spike_${titlvl}.fastq
       #echo ${filename}_spike_${titlvl}.fastq
       mv *backg.fastq background_subsamples

   done

done

cd ..
