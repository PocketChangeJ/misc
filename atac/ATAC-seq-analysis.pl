#!/usr/bin/env perl
###################################
# Author: Jiang (River) Li
# Email:  riverlee2008@gmail.com
# Date:   Mon Jun 10 09:36:10 2013
###################################
use strict;
use warnings;

# ATAC-Seq analysis pipeline

my $bowtie="bowtie";
my $index="/seq/reference/Homo_sapiens/UCSC/hg19/Sequence/BowtieIndex/genome";
my $samtools="samtools";
my $bedGraphToBigWig="bedGraphToBigWig";
my $genomeCoverageBed="genomeCoverageBed";
my $chromosomesize="/seq/reference/Homo_sapiens/UCSC/hg19/Annotation/Genes/ChromInfo.txt";

my $dir="../align";
mkdir "$dir" if (! -e "$dir");

#my @fastq=<../Data/Intensities/BaseCalls/*.gz>;
my @fastq=<../rawdata/*.fastq>;
# For pair-end
my %files;
foreach my $f (@fastq){
    my $n=$f;
    print $f,"\n";
    if($f=~/.*\/(.*?)_R(\d)/){
        $files{$1}->{$2}=$f;
        print $1,"\t",$2,"\n";
     }
}
foreach my $n (keys %files){
    next if ($n=~/Undeter/);
    my $out="${n}_ATAC_seq_analysis_pipeline.sh";
    open(OUT,">$out") or die $!;

    print OUT <<BASH;
#!/bin/bash
###############################
cd $dir
 
###############################
# Alignment
###############################
# 1.1 Alignment 
echo 'bowtie alignment' `date`
$bowtie --chunkmbs 2000 -p 24 -S -m 1 -X 2000  -t $index -1 $files{$n}->{1} -2 $files{$n}->{2}  ${n}.sam
samtools view -bS ${n}.sam |samtools sort - $n

# 1.2 Sam to bam and only output those mapped
echo "sam to bam (only output mapped)" `date`
$samtools view -b  -F 4 ${n}.bam >${n}_norm_sorted.bam

# 1.3 Delete not sorted bam
echo "delete bam" `date`
rm -rf ${n}.sam

# 1.4 remove duplicates and only get non chrM
echo "remove duplicates" `date`
$samtools rmdup  ${n}_norm_sorted.bam ${n}_norm_sorted_rmdup.bam
samtools view -h ${n}_norm_sorted_rmdup.bam | perl -lane 'print \$_ if \$F[2] ne "chrM"' |samtools view -bS - >${n}_norm_sorted_rmdup_nochrM.bam
$samtools index ${n}_norm_sorted_rmdup_nochrM.bam

# 1.5 make fragment bed
getFragmentBed.pl ${n}_norm_sorted_rmdup_nochrM.bam ${n}_fragment.bed

# 1.6 bedGraph
echo "make bedGraph" `date`
sort -k1,1 -k2,2n ${n}_fragment.bed |bedItemOverlapCount mm9 -chromSize=$chromosomesize stdin|sort -k1,1 -k2,2n >../tracks/${n}.bedGraph

# 1.7 bigwig
echo "make  bigwig" `date`
bedGraphToBigWig ../tracks/${n}.bedGraph $chromosomesize ../tracks/${n}.bw

BASH


}


