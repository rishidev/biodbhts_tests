#!/usr/bin/env perl

#
#
#
use Bio::DB::Sam ;


@test_files = ('data/some nonsense','data/yeast.sorted.cram','data/yeast.sorted.bam','data/yeast.unsorted.sam') ;


for $f (@test_files)
{
  printf "\nGetting Reads from $f\n" ;
  $read_fh = Bio::DB::HTS->open($f,"r") ;
  if( $read_fh )
  {
    printf( "\tFile open successful.\n" ) ;
    
    $read_fh->close() ;
  }
  else
  {
    printf( "\tError:File not opened.\n" ) ;
  }
}






