#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email:  riverlee2008@gmail.com
# Date:   Mon Aug  4 10:44:59 2014
###################################
use strict;
use warnings;

#####################
# Loop file in the align folder
# Get total reads, chrM reads and duplication reads

#Loop files
my @bams = <../align/*.bam>;
print join "\t",("Sample","TotalReads","InitialMappedReads","RemovechrM","\%chrM","RemoveDuplicates","\%Duplicates\n");
foreach my $bam (@bams){
    next if ($bam=~/_norm_/);
#    next if ($bam!~/D14/);
#    print $bam,"\n";
    my $name = $bam;
    $name=~s/.*\/|\.bam//g;
    my $total=getTotalReads($bam);
    my $totalMapped=getTotalMappedReads($bam);
    my $totalMappedChrM=getChrMappedReads($bam);
    my $afterremoveChrM=$totalMapped-$totalMappedChrM;

    my $bam2="../align/${name}_norm_sorted_rmdup_nochrM.bam";
    my $totalremoveDup = getTotalMappedReads($bam2);
    my $chrMP=mydivid($totalMappedChrM,$totalMapped);
    my $dupP = mydivid($afterremoveChrM-$totalremoveDup,$afterremoveChrM);

    print join "\t",($name,$total,$totalMapped,$afterremoveChrM,$chrMP,$totalremoveDup,$dupP);
    print "\n";
}

sub mydivid{
    my ($a,$b) = @_;
    my $p=sprintf("%.2f",$a/$b*100);
    return $p;
}
sub getTotalMappedReads{
    my $bam = shift;
    my $t = `samtools idxstats $bam|grep -v '*' |cut -f3 |paste -sd+ |bc`;
    $t=~s/\r|\n//g;
    return int ($t/2);
}

sub getChrMappedReads{
    my $bam = shift;
    my $t = `samtools idxstats $bam|grep  'chrM' |cut -f3 |paste -sd+ |bc`;
    $t=~s/\r|\n//g;
    return int ($t/2);
}

sub getTotalReads{
    my $bam = shift;
    my $t=`bammapped $bam | tr " " "+"|bc`;
    $t=~s/\r|\n//g;
    return int ($t/2);
}



