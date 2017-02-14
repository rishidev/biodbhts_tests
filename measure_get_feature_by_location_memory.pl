#!/usr/bin/env perl

#
# Display alignments across SAM/BAM/CRAM file formats.
#
use Bio::DB::HTS ;
use Memory::Usage ;

use strict ;

my @test_files = ('data/yeast.sorted.bam','data/yeast.sorted.cram') ;
my $fasta_file = "data/yeast.fasta" ;
my $sequence_id = "VII" ;

print( "High Level tests for $sequence_id\n" ) ;
for my $f (@test_files)
{
 print( "da:Opening File:$f\n" ) ;
 # high level API
 my $mu = Memory::Usage->new();
 $mu->record("starting $f");
 my $hts = Bio::DB::HTS->new(-bam  => $f,
                             -fasta => $fasta_file,
                             -autoindex => 1,
			     ) ;
 $mu->record("opened $f");
 my @targets    = $hts->seq_ids ;
 my $num_targets = scalar @targets ;
 print("$num_targets targets found\n") ;

 my $start = 50 ;
 my $blocksize = 15000 ;

 while( $start < 1090940 )
 {
   my $end = $start + $blocksize ;
   my @alignments = $hts->get_features_by_location(-seq_id => $sequence_id,
                                                 -start  => $start,
                                                 -end    => $end,
                                                 ) ;
   my $num_alignments = scalar @alignments ;
   print("$num_alignments alignments found in $sequence_id:$start-$end\n") ;
   for my $a (@alignments)
   {
     # where does the alignment start in the reference sequence
     my $seqid  = $a->seq_id;
     my $a_start  = $a->start;
     my $a_end    = $a->end;
     my $strand = $a->strand;
     my $cigar  = $a->cigar_str;
     my $paired = $a->get_tag_values('PAIRED');

     # where does the alignment start in the query sequence
     my $query_start = $a->query->start;
     my $query_end   = $a->query->end;

     my $ref_dna   = $a->dna;        # reference sequence bases
     my $query_dna = $a->query->dna; # query sequence bases

     my @scores    = $a->qscore;     # per-base quality scores
     my $match_qual= $a->qual;       # quality of the match
     print( "\talignment found at:$seqid-$a_start\n" ) ;
   }
   $mu->record("$f $start");
   $start = $end ;
 }
 $mu->dump() ;
 $hts->hts_file->close() ;

}
