#my $seq="ataacttcgtatagcatacattatacgaagtta";
#$seq="AAGCAGGGCGCGC";
$seq="ataa cttcgtataa tgtatgctat acgaagttaT";
$seq=~s/\s+//g;
$seq=uc($seq);
$seq=~tr/ATCG/TAGC/;
$seq=reverse($seq);

print $seq,"\n\n";
