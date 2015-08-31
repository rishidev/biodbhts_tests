#!/usr/bin/env perl

#
# Test read 1 from SAM/BAM/CRAM file formats.
#
use Bio::DB::HTS ;

use strict ;

my @test_files = ('data/file fail to open test','data/yeast.sorted.cram','data/yeast.sorted.bam','data/yeast.unsorted.sam') ;


for my $f (@test_files)
{
  printf "\nGetting Reads from $f\n" ;
  my $read_fh = Bio::DB::HTSfile->open($f,"r") ;
  if( $read_fh )
  {
    printf( "File open successful.\n" ) ;

    my $header = $read_fh->header_read() ;
    my $index = Bio::DB::HTSfile->index_open($f) ;

    if( defined $index )
    {
      printf( "Index returned something\n" ) ;
    }
    else
    {
      printf( "Index returned nothing\n" ) ;
    }

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
