#!/usr/bin/env perl

#
# Test read 1 from SAM/BAM?CRAM file formats.
#
use Bio::DB::HTS ;

use strict ;

my @test_files = ('data/file fail to open test','data/yeast.sorted.cram','data/yeast.sorted.bam','data/yeast.unsorted.sam') ;


for my $f (@test_files)
{
  printf "\nGetting Reads from $f\n" ;
  my $read_fh = Bio::DB::HTS->open($f,"r") ;
  if( $read_fh )
  {
    printf( "\tFile open successful.\n" ) ;

    my $header = $read_fh->header_read() ;

    for(my $i=0 ; $i <= 5 ; $i++)
    {
      my $alignment = Bio::DB::HTS::Alignment->new() ;
      $read_fh->read1($header,$alignment) ;
      my $qseq = $alignment->qseq() ;
      printf( "raw alignment details:" ) ;
      printf( "$qseq\n" ) ;
    }

    $read_fh->close() ;
    printf( "\tFile closed.\n" ) ;
  }
  else
  {
    printf( "\tError:File not opened.\n" ) ;
  }
}






