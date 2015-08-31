#!/usr/bin/env perl

#
# Display alignments across SAM/BAM/CRAM file formats.
#
use Bio::DB::HTS ;

use strict ;

my @test_files = ('data/yeast.sorted.bam','data/yeast.unsorted.sam','data/yeast.sorted.cram') ;
my $fasta_file = "data/yeast.fasta" ;
my $sequence_id = "VII" ;

print( "da:High Level tests for $sequence_id\n" ) ;
for my $f (@test_files)
{
 print( "da:Opening File:$f\n" ) ;
 # high level API
 my $hts = Bio::DB::HTS->new(-bam  => $f,
                             -fasta => $fasta_file,
                             -autoindex => 1,
			     ) ;
 print( "da:File Opened Successfully\n" ) ;
 my @targets    = $hts->seq_ids ;
 my $num_targets = scalar @targets ;
 print("$num_targets targets found\n") ;
 my @alignments = $hts->get_features_by_location(-seq_id => $sequence_id,
                                                 -start  => 50,
                                                 -end    => 5000,
                                                 ) ;
 my $num_alignments = scalar @alignments ;
 print("$num_alignments alignments found\n") ;
 for my $a (@alignments)
 {
    # where does the alignment start in the reference sequence
    my $seqid  = $a->seq_id;
    my $start  = $a->start;
    my $end    = $a->end;
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

    print( "$cigar\n" ) ;
 }

 my @pairs = $hts->get_features_by_location(-type   => 'read_pair',
                                            -seq_id => $sequence_id,
                                            -start  => 500,
                                            -end    => 800);

 for my $pair (@pairs)
 {
    my $length                    = $pair->length;   # insert length
    my ($first_mate,$second_mate) = $pair->get_SeqFeatures;
    my $f_start = $first_mate->start;
    my $s_start = $second_mate->start;
 }

}
