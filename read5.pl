#!/usr/bin/env perl

#
#
#
use Bio::DB::Sam ;


@test_files = ('some nonsense','yeast.cram') ;


for $f (@test_files)
{
  printf "Getting Reads from $f\n" ;
  $read_fh = open($f) ;
  if( $read_fh )
  {
    printf( "\tFile open successful.\n" ) ;
  }
  else
  {
        printf( "\tError:File not opened.\n" ) ;
  }
  close($read_fh) ;
}






