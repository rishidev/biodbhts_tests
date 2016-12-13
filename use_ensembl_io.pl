#!/usr/bin/env perl

#
# Test read 1 from SAM/BAM/CRAM file formats.
#
use Bio::EnsEMBL::IO::Adaptor::HTSAdaptor ;
use Bio::DB::HTS ;

use strict ;

my @test_files = (
                  'data/file fail to open test',
#                  'data/yeast.sorted.cram',
#                  'data/yeast.sorted.bam',
#                  'data/yeast.unsorted.sam',
                  'ftp://ftp.ensembl.org/pub/release-82/bamcov/gallus_gallus/genebuild/Galgal4.ICGSC.breast.2.bam',
                  'ftp://ftp.ebi.ac.uk/pub/databases/arrayexpress/data/atlas/rnaseq/SRR527/SRR527165/SRR527165.cram',
                  'http://www.ebi.ac.uk/~rishi/test_files/chicken.chrZ.smallbrainz2.ena.sorted.cram',
                  'http://www.ebi.ac.uk/~rishi/test_files/chicken.chrZ.smallbrainz2.ena-no_index.sorted.cram',
                 ) ;


for my $f (@test_files)
{
  print "Opening file $f\n" ;
  my $hts_adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($f) ;
  my $hts_file = $hts_adaptor->htsfile_open() ;
  if( $hts_file )
  {
    my $index = $hts_adaptor->htsfile_index() ;
    $hts_adaptor->htsfile_close() ;
    print "Closed file\n" ;
  }
}
