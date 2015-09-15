#!/usr/bin/perl
# subtype crawl_db

use strict;
use warnings;

open(DB, "$ARGV[1]") or die "ERROR: cannot open $ARGV[1]:$!\n";

my $subtype = $ARGV[0];

while(<DB>){
    chomp;
    my @line = split("\t", $_);
    if($subtype eq "na"){
	!system("wget -x $line[1]") or die "ERROR: cannot download data from TCGA\n";
    }else{
	next unless $line[0] eq $subtype;
	!system("wget -x $line[1]") or die "ERROR: cannot download data from TCGA\n";
    }
}

