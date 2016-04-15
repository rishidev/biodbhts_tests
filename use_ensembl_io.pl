#!/usr/bin/env perl

#
# Test read 1 from SAM/BAM/CRAM file formats.
#
use Bio::EnsEMBL::IO::Adaptor::HTSAdaptor ;
use Bio::DB::HTS ;

use strict ;

my @test_files = (
                  'data/file fail to open test',
                  'data/yeast.sorted.cram',
                  'data/yeast.sorted.bam',
                  'data/yeast.unsorted.sam',
                  'ftp://ftp.ensembl.org/pub/release-82/bamcov/gallus_gallus/genebuild/Galgal4.ICGSC.breast.2.bam',
                  'ftp://ftp.ebi.ac.uk/pub/databases/arrayexpress/data/atlas/rnaseq/SRR527/SRR527165/SRR527165.cram',
                 ) ;


for my $f (@test_files)
{
  print "Opening file $f\n" ;
  my $hts_adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($f) ;
  $hts_adaptor->htsfile_open() ;
  $hts_adaptor->htsfile_close() ;
  print "Closed file\n" ;
}
