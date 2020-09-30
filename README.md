# Usefulscriptsforgeneratingreads

A collection of useful scripts to generate reads (Illumina, Nanopore, etc.) for testing and validation of metagenomics classifiers.

# makenakedreads.sh

A script that, provided dwgsim is installed, mostly automates the generation of reads (Illumina,etc.) and produces fastq with specified read counts. 

The command to use is ./PATH/makenakedreads.sh, where PATH is the location of makenakedreads.sh, and is run in the folder where you want the resulting reads to be generated and saved.

List of parameters in the script:
targetgenomefiles=($(ls PATH)) - the PATH to where the genome fastas are located
titerlvls="5 50 500 5000 50000" - a space seperated list of integers that correspond to how many reads are desired to be generated in the output fastqs 
readtype=0 - the type of read to be generated ( 0 corresponds to Illumina reads)
matereadtype=2 - the type of matched read to be generated for each read (0 corresponds to paired-end reads)
R1errorprofile="0.001-0.01" - the error profile the read generator uses to generate reads (see dwgsim manual for more info) for read 1 in pair
R2errorprofile="0.001-0.01" - the error profile the read generator uses to generate reads (see dwgsim manual for more info) for read 2 in pair
maxreadpairdistance=500 - the maximum distance in the genome the read generator allows between reads in pair
stdreadpairdistance=10 - allows you to indicate the Variance of the distnace between reads, i.e. the higher this number. the larger a range of distance between reads in a pair will occur 
R1length=75 - the actual sequence length of read 1
R2length=75 - the actual sequence length of read 2
maxNallowed=0 -  the number of nucleotide positions allowed to be generated with a completely ambiguous nucloetide (N) 
numreads=1000000 -  the initial number of reads that the tool will generateas a batch, all the following fastqs will be a subset of these read and this number should be atleast as big as the largest number in "titerlvls" 

# makespikeinfilesv1.sh

A script that, provided dwgsim is installed, mostly automates the generation of reads (Illumina,etc.) and produces fastq with specified read counts and then spikes them into background reads at specified levels. 

The command to use is ./PATH/makespikeinfilesv1.sh, where PATH is the location of makenakedreads.sh, and is run in the folder where you want the resulting reads to be generated and saved.

List of parameters in the script:
ifpattern="PAN-1071-QCS_S1_L001_R*_001_*.fastq" - specifies the pattern of fastqs you want to have generated reads spiked into, * being wildcards, to expand out to at least 2 files
targetgenomefiles=($(ls orggenomes/*.fa)) - specifies the path to the folder that has all desired genomes, in fasta format, to be used to make reads
titerlvls="5 50" - a space seperated list of integers that correspond to how many reads are desired to be generated in the output fastqs 
workdir=intermediatefile_titerlvls - the working directory where all intermediate files and the final files will be deposited

# duplicatereadsinfastq.sh

A script that dupicates the reads in a reference fastq by some number of times (to up-sample a fastq) and then trims the number of reads to a certain number of lines (to control the number of reads in a file) 

The command to use is ./PATH/duplicatereadsinfastq.sh, where PATH is the location of makenakedreads.sh, and is run in the folder where you want the resulting fastq to be generated.

List of parameters in the script:
INITFILE="PAN-1071-QCS_S1_L001_R1_001_a.fastq" - specifies the file to be used for the up-sampling of reads
NUMCOPIES=25 - number of times each of the reads will be copied in the outputfile before trimming
TRIMNUMBER=30000000 - number of lines the resulting file should have at the end
OUTFILE=${INITFILE%.*}_dup${NUMCOPIES}_trim${TRIMNUMBER}.fastq - filename (or path) for the resulting file

