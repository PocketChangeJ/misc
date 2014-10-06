#!/usr/bin/perl
use strict;
use warnings;

my @files = <*.bw>;
foreach my $f (@files){
    my $n=$f;
    $n=~s/\.bw//g;
    $n=~s/_norm_sorted_rmdup//g;
    my $str="track type=bigWig name=\"$n\" description=\"$n\" color=25,125,125 visibility=full bigDataUrl=https://s3.amazonaws.com/orolab/atac-seq_07292014/$f maxHeightPixels=32:32:70 autoScale=on alwaysZero=on";

    print $str,"\n";
}

