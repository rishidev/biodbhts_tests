#!/usr/bin/env perl

#
# Display alignments across SAM/BAM/CRAM file formats.
#
use Bio::DB::HTS ;

use strict ;

my @test_files = ('data/yeast.sorted.bam','data/yeast.unsorted.sam','data/yeast.sorted.cram') ;
my $fasta_file = "data/yeast.fasta" ;
my $sequence_id = "VII" ;


for my $f (@test_files)
{
  my $hts = Bio::DB::HTS->new(-bam  => $f,
                             -fasta => $fasta_file,
                             -autoindex => 1,
			     ) ;
  print( "gf:File Opened Successfully\n" ) ;
  my @targets    = $hts->seq_ids ;
  my $num_targets = scalar @targets ;
  print("gf:$num_targets targets found\n") ;

  my @pairs = $hts->get_features_by_location(-type   => 'read_pair',
                                            -seq_id => $sequence_id,
                                            -start  => 500,
                                            -end    => 800);



}
