#!/bin/bash

# Take the raw data (fastq) and run FastQC on it

#1)  get to the parental folder
cd ../

#2) make directory if not exists
qcdir="QC_raw"
if [ ! -d $qcdir ]; then
    mkdir $qcdir
fi
 
#3) loop the files in the rawdata folder and run the fastqc
rawdatadir="rawdata"
command="fastqc -t 14 -o $qcdir --nogroup "
#for f in `ls $rawdatadir/*.fastq|grep -P "GRR|RSN"|grep -v Remove|grep -v fai`;do
for f in `ls $rawdatadir/*.fastq|grep -v fai`;do
    echo $f
    n=`basename $f`
#    echo $n
    nn=`echo $n |cut -f1 -d"."`
#    echo $nn
    nnn=`ls $qcdir|grep $nn `
#    echo $nnn
    if [ "$nnn" == "" ]; then
        echo $nnn
        command="$command $f"
    fi
   
done

#4) print the command and run it
echo $command 
time $command

#5) Merget the report together
merge_fastqc_report.pl -d QC_raw
