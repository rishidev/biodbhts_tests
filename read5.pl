#!/usr/bin/env perl

#
# Test read 1 from SAM/BAM/CRAM file formats.
#
use Bio::DB::HTS ;

use strict ;

my @test_files = (
                  'data/file fail to open test',
                  'data/yeast.sorted.cram',
                  'data/yeast.sorted.bam',
                  'data/yeast.unsorted.sam',
                  'ftp://ftp.ensembl.org/pub/release-82/bamcov/gallus_gallus/genebuild/Galgal4.ICGSC.breast.2.bam',
                  'ftp://ftp.ebi.ac.uk/pub/databases/arrayexpress/data/atlas/rnaseq/SRR527/SRR527165/SRR527165.cram',
                  'http://www.ebi.ac.uk/~rishi/test_files/chicken.chrZ.smallbrainz2.ena.sorted.cram',
                  'https://www.ebi.ac.uk/~rishi/test_files/chicken.chrZ.smallbrainz2.ena.sorted.cram'
                 ) ;


for my $f (@test_files)
{
  printf "\nGetting Reads from $f\n" ;
  my $read_fh = Bio::DB::HTSfile->open($f,"r") ;
  if( $read_fh )
  {
    printf( "File open successful.\n" ) ;

    my $header = $read_fh->header_read() ;

    for(my $i=0 ; $i <= 5 ; $i++)
    {
      my $alignment = $read_fh->read1($header) ;
      my $qseq = $alignment->qseq() ;
      printf( "  raw alignment qseq:" ) ;
      printf( "$qseq\n" ) ;
    }

    my $header = $read_fh->header_read() ;

    $read_fh->close() ;
    printf( "File closed.\n" ) ;
  }
  else
  {
    printf( "\tError:File not opened.\n" ) ;
  }
}
