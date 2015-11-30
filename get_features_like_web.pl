#!/usr/bin/env perl

#
# Test as for the ensembl webcode bam.pm call to HTSAdaptor to get features
#
use Bio::EnsEMBL::IO::Adaptor::HTSAdaptor ;
use strict ;
use warnings ;
use Bio::DB::HTS;
use Data::Dumper;
my $DEBUG = 1;
my $url = "http://www.ebi.ac.uk/~rishi/test_files/small_brainz.2.bam" ;

my $adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($url);
$adaptor->fetch_alignments_filtered("Z", "9897818", "9987257");
print "Exiting\n" ;
