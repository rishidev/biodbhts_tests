#!/usr/bin/env perl

#
# Test read 1 from BAM file formats.
#
use Bio::DB::Sam ;

use strict ;

#just doing with the BAM file
my @test_files = ('data/yeast.sorted.bam') ;

for my $f (@test_files)
{
  printf "\nGetting Reads from $f\n" ;
  my $read_fh = Bio::DB::Bam->open($f,"r") ;
  if( $read_fh )
  {
    printf( "File open successful.\n" ) ;

    my $header = $read_fh->header() ;

    for(my $i=0 ; $i <= 5 ; $i++)
    {
      my $alignment = $read_fh->read1($header) ;
      my $qseq = $alignment->qseq() ;
      printf( "  raw alignment qseq:" ) ;
      printf( "$qseq\n" ) ;
    }

    $read_fh->close() ;
    printf( "File closed.\n" ) ;
  }
  else
  {
    printf( "\tError:File not opened.\n" ) ;
  }
}
