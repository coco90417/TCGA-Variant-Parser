#!/usr/bin/perl
# subtype crawl_db directory_of_tcga_mafs output_ann_file

use strict;
use warnings;

### load locations of all maf files
my %maf;
open(CRAWL, "$ARGV[1]") or die "ERROR: cannot open crawling directory:$!\n";
while(<CRAWL>){
    chomp;
    my @line = split("\t", $_);
    if($ARGV[0] eq "na"){
	$maf{$line[1]} = $line[0];
    }else{
	next unless $ARGV[0] eq $line[0];
	$maf{$line[1]} = $line[0];
    }
}
close CRAWL;


### parse maf files
die "ERROR: cannot open maf file directory:$!\n" unless -d $ARGV[2];
my %variant;
foreach my $mafFile (sort keys %maf){
    my $file = $ARGV[2] . "/" . $mafFile;
    &parseMaf($file, $mafFile);
}

open(OUT, ">$ARGV[3]") or die "ERROR: cannot open $ARGV[3] for write:$!\n";
foreach my $sample (sort keys %variant){
    foreach my $content (sort keys %{$variant{$sample}}){
	print OUT "$content\n";
    }
}

################## subs ##################

sub parseMaf{

    my $fileName = shift;  # whole path
    my $mafFileName = shift;  # only maf from current directory
    open(MAF, "$fileName") or die "ERROR: cannot open maf file$!\n";
# parse header
    my ($chr, $sta, $end, $ref, $alt1, $alt2, $sample);
    while(<MAF>){
	chomp;
	my $header = $_;
	if($header =~ /^Hugo/ || $header =~ /^HUGO/){
	    my @line = split("\t", $_);
	    for(0..$#line){
		if($line[$_] eq "Chromosome" || $line[$_] =~ "CHROM" ){
		    $chr = $_;
		}elsif($line[$_] =~ /^Start/ || $line[$_] =~ /^STA/){
		    $sta = $_;
		}elsif($line[$_] =~ /^End/ || $line[$_] =~ /^END/){
		    $end = $_;
		}elsif($line[$_] =~ /^Reference_Allele/ || $line[$_] =~ /^REF/){
		    $ref = $_;
		}elsif($line[$_] =~ /^Tumor_Seq_Allele1/ || $line[$_] =~ /^TUMOR_SEQ_ALLELE1/){
		    $alt1 = $_;
		}elsif($line[$_] =~ /^Tumor_Seq_Allele2/ || $line[$_] =~ /^TUMOR_SEQ_ALLELE2/){
		    $alt2 = $_;
		}elsif($line[$_] =~ /^Tumor_Sample_Barcode/ || $line[$_] =~ /^TUMOR_SAMPLE_ID/ || $line[$_] =~ /^TUMOR_SAMPLE_BARCODE/){
		    $sample = $_;
		}
	    };
	    last;
	};
	next;
    }
# parse real stuff
    while(<MAF>){
	chomp;
	next if $_ =~ /^\s$/;
	my @line = split("\t", $_);
	my $alt = $line[$ref] eq $line[$alt1] ? $line[$alt2] :  $line[$alt1];
	my $content = "$line[$chr]\t$line[$sta]\t$line[$end]\t$line[$ref]\t$alt\t$line[$sample]\t$maf{$mafFileName}";
	$variant{$line[$sample]}{$content} = 1;
    }
    close MAF;
}



