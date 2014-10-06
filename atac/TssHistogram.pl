#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email:  riverlee2008@gmail.com
# Date:   Tue Jul  1 15:38:13 2014
###################################
use strict;
use warnings;
my $tss="/seq/softwares/homer4.4/data/genomes/hg19/hg19.tss";
my $com="annotatePeaks.pl $tss hg19 -size 4000 -hist 10 -d ";

my $tagdirs=`ls ../tags/ |grep -v make |sort -n`;
foreach my $tag (split "\n", $tagdirs){
    #print $tag,"\n\n";
    $com.=" ../tags/$tag ";
}

$com.=" > tss_4k_hist10_1-12_histogram.txt";
print $com,"\n";

#`$com`;
