#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email: riverlee2008@gmail.com
# Date: Wed Apr  9 15:03:29 2014
###################################
use strict;
use warnings;
my @beds=<../*_fragment_preShift75.bed>;
foreach my $bed (@beds){
    next if ($bed!~/NHK/);
    my $n=$bed;
    $n=~s/.*\/|_fragment_preShift75\.bed//g;
    print "doing $n ..\n";

    my $com = "macs2 callpeak -t $bed -g hs -n $n -f BED --nomodel --shiftsize 75";
    print $com,"\n\n";
    `$com`;
}

