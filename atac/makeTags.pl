#!/usr/bin/env perl
###################################
# Author: Jiang (River) Li
# Email:  riverlee2008@gmail.com
# Date:   Tue May  6 15:44:58 2014
###################################
use strict;
use warnings;


my @bams = <../align/*_fragment.bed>;
foreach my $bam (@bams){
    next if ($bam=~/normdup/);
    next if ($bam!~/NHK/);
    print $bam,"\n";
    my $n=$bam;
    $n=~s/.*\/|_fragment\.bed//g;
    print $n,"\n\n";

    # makeTag
    my $com="makeTagDirectory TagDir_${n}/ $bam";
    print $com,"\n\n";
`$com`; 
    }
