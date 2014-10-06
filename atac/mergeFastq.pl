#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email:  riverlee2008@gmail.com
# Date:   Thu Jul 31 10:22:31 2014
###################################
use strict;
use warnings;

# Concat individial fastq files of each sample together

my $indir="../initial";
my $outdir="../rawdata";

# Read folder from ../initial
opendir(DIR,$indir) or die $!;
my @folders = grep {$_ ne ".." && $_ ne "."} readdir DIR; 
close DIR;


foreach my $f (@folders){
    my $n = $f;
    $n=~s/[\-_]Ad.*|\)//gi;
    $n=~tr/#\(/__/;
    print $f,"\t$n\n";

    my $com1="zcat ";
    my $com2="zcat ";
    
    my @files=<$indir/$f/*fastq.gz>;
    my @mate1;
    my @mate2;
    foreach my $fastq (@files){
        my $mate=1;
        my $num="";
        if($fastq=~/_R([12])_(\d+)\.fastq\.gz/){
            $mate=$1;
            $num=$2;
        }
        print "\t$fastq\tmate:$mate\tnum:$num\n";
        if($mate == 1){
            push @mate1,$fastq;
        }else{
            push @mate2,$fastq;
        }
    }
    foreach my $tmp (@mate1){
        $com1.=" $tmp";
    }
    foreach my $tmp (@mate2){
        $com2.=" $tmp";
    }

    $com1.=" >${outdir}/${n}_R1.fastq";
    $com2.=" >${outdir}/${n}_R2.fastq";

    open(OUT,">${n}_mergeFastq.sh") or die $!;
    print OUT "#!/bin/bash\n";
    print OUT "echo Merge sample $n \`date\`\n";
    print OUT "echo Doing mate 1 \`date\`\n";
    print OUT "$com1\n\n";
    print OUT "echo Doing mate 2 \`date\`\n";
    print OUT "$com2\n";
    close OUT;
}


