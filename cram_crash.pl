# script to retrieve a small piece of sequence and see what happens

use Bio::EnsEMBL::IO::Adaptor::HTSAdaptor ;
use strict ;
use warnings ;
use Bio::DB::HTS;
use Data::Dumper;

my $DEBUG = 1;
my $url = "ftp://ftp.ensembl.org/pub/release-77/bam/homo_sapiens/genebuild/GRCh38.illumina.adipose.1.bam" ;


print "Using Bio::DB::HTS\n" ;


print "Using ensembl-io\n" ;
my $io_adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($url);
$io_adaptor->fetch_alignments_filtered("17","64205516","64205825");

print "Exiting\n" ;
