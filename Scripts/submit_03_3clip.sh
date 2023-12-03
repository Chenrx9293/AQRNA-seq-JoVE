#!/bin/sh
#SBATCH -N 1 #request Bourne shell as shell for job
#SBATCH -n 8

module load fastxtoolkit/0.0.13
echo "clip 3' linker; nodes: 1; mem: 29G"
echo "Start - `date`"
echo "----"

for f in `ls fastq/*/*_1_sequence.fastq`
do
start="`date +%s`"
	t=`echo $f | cut -d "." -f1`
	echo "$t"
	fastx_clipper -a CACTCGGGCA -Q33 -v -n -M 8 -i $f -o ${t}.3clipped.fq
	#-v output verbose report
	#-n do not discard sequences that contain N
	#-M require minimum adapter match of 8
end="`date +%s`"
echo "$((($end-$start)/60)) minutes and $((($end-$start)%60)) seconds elapsed."	
echo "---"
done

echo "----"
echo "Finish - `date`"
