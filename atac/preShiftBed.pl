#!/usr/bin/env perl
###################################
# Author: Jiang Li
# Email: riverlee2008@gmail.com
# Date: Wed Apr  9 14:58:03 2014
###################################
use strict;
use warnings;

my $size=75;
my @beds=<../align/*_fragment.bed>;
foreach my $bed (@beds){
    next if ($bed=~/normdup/);
    next if ($bed!~/NHK/);
    my $n=$bed;
    $n=~s/.*\/|_fragment\.bed//g;
    print "doing $n .. \n";

    open(IN,"$bed") or die $!;
    open(OUT,">${n}_fragment_preShift${size}.bed") or die $!;
    while(<IN>){
        chomp;
        my($chr,$start,$end,$name,$score,$strand) = split "\t";
        if($strand eq "+"){
            $start = $start - $size;
            $end = $end - $size;
        }else{
            $start = $start + $size;
            $end = $end + $size;
        }
        $start = 0 if ($start <0);
        print OUT join "\t",($chr,$start,$end,$name,$score,$strand."\n");
    }
    close IN;
    close OUT;
}
