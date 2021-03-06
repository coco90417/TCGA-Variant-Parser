#!/usr/bin/perl
use strict;
use warnings;
use Pod::Usage;
use Getopt::Long;

&processArguments();

sub processArguments {
    my ($help, $manual, $subtype, $crawldb, $db,  $ann);
    $subtype = "na";
    GetOptions('help|h' => \$help,
	       'manual|man|m' => \$manual,
	       'subtype|s=s' => \$subtype,
	       'crawldb|c=s' => \$crawldb,
	       'db=s' => \$db,
	       'annovar|ann=s' => \$ann
	) or pod2usage();
    $subtype = lc($subtype);
    if($subtype ne "laml" and $subtype ne "acc" and $subtype ne "blca" and $subtype ne "brca" and $subtype ne "cesc" and $subtype ne "chol" and $subtype ne "esca" and $subtype ne "fppp" and $subtype ne "gbm" and $subtype ne "hnsc" and $subtype ne "kich"  and $subtype ne "kirc"  and $subtype ne "kirp" and $subtype ne "lihc" and $subtype ne "luad" and $subtype ne "lusc" and $subtype ne "dlbc" and $subtype ne "meso" and $subtype ne "ov" and $subtype ne "paad" and $subtype ne "pcpg" and $subtype ne "prad" and $subtype ne "read" and $subtype ne "sarc" and $subtype ne "skcm" and $subtype ne "stad" and $subtype ne  "tgct" and $subtype ne "thym" and $subtype ne "thca" and $subtype ne "ucs" and $subtype ne  "ucec" and $subtype ne "uvm" and $subtype ne "na"){
	print "ERROR: please enter a valid subtype\n";
	pod2usage();
    }
    $help and pod2usage (-verbose=>1, -exitval=>1, -output=>\*STDOUT);
    $manual and pod2usage (-verbose=>2, -exitval=>1, -output=>\*STDOUT);
    @ARGV == 1 or pod2usage ();
    if($ARGV[0] ne "download" and $ARGV[0] ne "parse"){
	print "ERROR: please chose to either download or parse somatic variants from TCGA\n";
	pod2usage();
    }
    if($ARGV[0] eq "download"){
	if ($subtype and $crawldb){
	    my $address = $0;
	    $address =~ s/tcga_variant_parser/download/;
	    !system("perl $address $subtype $crawldb") or die "ERROR: cannot run downloading\n";;
	}else{
	    print "ERROR: please enter valid subtype and crawling_db address for download\n";
	    pod2usage();
	}
    }
    if($ARGV[0] eq "parse"){
	if ($subtype and $crawldb and $db and $ann){
            my $address = $0;
            $address =~ s/tcga_variant_parser/parse/;
	    # subtype crawl_db directory_of_tcga_mafs output_ann_file
            !system("perl $address $subtype $crawldb $db $ann") or die "ERROR: cannot run downloading\n";
        }else{
            print "ERROR: please enter valid subtype and crawling_db address for download\n";
            pod2usage();
        }
    }
}



######################################################################################################################################
############################################################ manual page #############################################################
######################################################################################################################################

=head1 NAME                                                                                                                                                                                                                                                                 
        
 TCGA Variant Parser
                                                              
=head1 SYNOPSIS
                                                                                                                                                                                                      
 tcga_variant_parser.pl [options] <input>                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                               
 Options:                                                                                                                                                                                                                                                                     
        -h, --help                      print help message   
        -m, --manual                    print manual message
        -s, --subtype                   subtype of the cancer, valid options include "ACC", "BLCA", "BRCA", "CESC", "CHOL", "ESCA", "GBM", "HNSC", "KICH", "KIRC", "KIRP", "LAML", "LGG", "LIHC", "LUSC", "OV", "PAAD", "PCPG", "PRAD", "SARC", "SKCM", "STAD", "TGCT", "TGCA", "THYM", "UCEC", "UCS", "UVM". This option is case insensitive
        -c, --crawldb                   location of crawl*.db
        --db                            path to the tcga-data.nci.nih.gov/ directory produced after downloading variants from TCGA
        -ann, --annovar                 output ANNOVAR file name
    
 Function: TCGA Variant Parser download somatic mutation maf files from TCGA data portal and parse them into ANNOVAR input format
    
 Example: tcga_variant_parser.pl download -s ACC -c crawl_20140728.db
          tcga_variant_parser.pl parse -s ACC -c crawl_20140728.db --db . -ann acc.ann 
 
 Version: 1.0
 
 Last update: Tue Sep 15 15:58:26 PDT 2015
 
=head1 OPTIONS
=over 8
=item B<--help>
 print a brief usage message and detailed explanation of options.
=item B<--manual>
 print the manual page and exit.
=back
=cut
