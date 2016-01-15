
# get the figures to go with the Bio-HTS repo tests


use Bio::DB::HTS;
use Bio::DB::HTS::AlignWrapper;

my $cramfile = "data/yeast.sorted.cram";
my $hts_file     = Bio::DB::HTSfile->open($cramfile);
my $header  = $hts_file->header_read();
my $targets = $header->n_targets;
printf( "n_targets value is $targets\n" ) ;

my $target_names = $header->target_name;
my $target_lens = $header->target_len;
my $num_targets = scalar @$target_names ;

print( "------- $num_targets targets ---------\n" ) ;
print($target_names->[0].":".$target_lens->[0]."\n");
print($target_names->[5].":".$target_lens->[5]."\n");
print($target_names->[10].":".$target_lens->[10]."\n");

print( "------- header text ---------\n" ) ;
print($header->text) ;

print( "------- FAIDX ---------\n" ) ;
my $region = 'X:51-1000' ;
my $fai = Bio::DB::HTS::Fai->open("data/yeast.fasta");
my $seq = $fai->fetch( $region );
my $seq_length = length $seq ;
print( "seq_length:$seq_length\n" ) ;

my $count;
while ( my $b = $hts_file->read1($header) )
{
  $count++ ;
}
print("Total read count:$count\n") ;


my @result = $header->parse_region($region);
my $num_results = scalar @result ;
print("$region read count:$num_results\n") ;
foreach my $r (@result)
{
  print("$r\n") ;
}

print( "------- Index ---------\n" ) ;
Bio::DB::HTSfile->index_build($cramfile);
my $index = Bio::DB::HTSfile->index_load($hts_file);

my @a;
my $print_region = sub {
        my ( $alignment, $data ) = @_;
        push @a, $alignment;
        return;
    };

$index->fetch( $hts_file, $header->parse_region($region),
                   $print_region, "foobar" );

    my %matches;
    my $fetch_back = sub {
        my ( $tid, $pos, $p ) = @_;
        my $p1 = $pos + 1;
        my $r  = $fai->fetch( $header->target_name->[$tid] . ":$p1-$p1" );
        for my $pileup (@$p) {
            my $b    = $pileup->b;
            my $qpos = $pileup->qpos;
            my $base =
              $pileup->indel == 0 ? substr( $b->qseq, $qpos, 1 ) :
              $pileup->indel > 0 ? '*' :
              '-';
            $matches{matched}++ if $r eq $base;
            $matches{total}++;
        }
    };


$index->pileup( $hts_file, $header->parse_region($region), $fetch_back );
print("Matches matched:".$matches{matched}."\n") ;
print("Matches total:".$matches{total}."\n") ;

my $coverage =
      $index->coverage( $hts_file, $header->parse_region('II'), 100, 100000 );
my $c = scalar @$coverage ;
print( "Coverage c:".$c."\n" );
my @cov = sort { $a <=> $b } @$coverage;

print( "c0:".$cov[0]."\n" ) ;
print( "c-1:".$cov[-1]."\n" ) ;



print( "------- HIGH LEVEL (LOCAL FILE) ---------\n" ) ;
for my $use_fasta ( 0, 1 )
{
    print("------ use_fasta $use_fasta -------\n") ;
    my $hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    print( "file contains ".$hts->n_targets." targets\n" ) ;
    my $joined_seq_ids = join $hts->seq_ids ;
    print( "joined_seq_ids:".$joined_seq_ids."\n" ) ;
#    print( "seq_ids 5".$hts->seq_ids[5]."\n" ) ;
#    print( "seq_ids 10".$hts->seq_ids[10]."\n" ) ;

    my $seg = $hts->segment('I');
    print( "Segment I length ".$seg->length."\n" ) ;
    my $seq = $seg->seq;
    print( "isa Bio::PrimarySeq=".$seq->isa('Bio::PrimarySeq')."\n" );

#now test the alignments
    my @alignments =
      $hts->get_features_by_location( -seq_id => 'I',
                                      -start  => 500,
                                      -end    => 20000 );
    my $num_alignments = scalar @alignments ;
    print( "num_alignments $num_alignments\n" ) ;

    my $qscore = scalar @{ $alignments[0]->qscore } ;
    my $dnalength = length $alignments[0]->dna ;
    print( "alignment 0 qscore ".$qscore."\n" ) ;
    print( "alignment 0 dna length ".$dnalength."\n" ) ;

# keys
    my @keys = $alignments[5]->get_all_tags;

    my %att = $alignments[5]->attributes;
    print( "num attributes ".scalar( keys %att )."\n" );
    foreach $a (sort(keys %att))
    {
        print $a, '=', $att{$a}, "\n";
    }
    print( "CIGAR:".$alignments[5]->cigar_str."\n") ;


    my $query = $alignments[0]->query;
    print( "".$query->start."\n" ) ;
    print( "".$query->end."\n" ) ;
    print( "".$query->length."\n" ) ;
    print( "".$query->dna."\n" ) ;
    print( "".$alignments[0]->dna."\n" ) ;
    print( "".$alignments[0]->strand."\n" ) ;
    print( "".$query->strand."\n" ) ;

    my $target = $alignments[0]->target;
    print( "target start".$target->start."\n" ) ;
    print( "target end".$target->end."\n" ) ;
    print( "target length".$target->length."\n" ) ;
    print( "".$target->dna."\n" ) ;
    print( "".reversec( $alignments[0]->dna )."\n" ) ;

    my @pads = $alignments[0]->padded_alignment;
    $a = scalar @pads ;
    print( "num pads".$a."\n");
    for $a (@pads)
    {
      print( $a."\n" ) ;
    }

#features
    my @features = $hts->features() ;
    $a = scalar @features ;
    print( "num features:".$a."\n");

}


print("-------------BAM version of tests-----------------\n") ;
my $hts = Bio::DB::HTS->new( -fasta        => "/home/rishi/coding/hts_dev/Bio-HTS/t/data/ex1.fa",
                                 -bam          => "/home/rishi/coding/hts_dev/Bio-HTS/t/data/ex1.bam",
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => 1, );

print( "file contains ".$hts->n_targets." targets\n" ) ;
my $joined_seq_ids = join $hts->seq_ids ;
print( "joined_seq_ids:".$joined_seq_ids."\n" ) ;


sub reversec {
    my $dna = shift;
    $dna =~ tr/gatcGATC/ctagCTAG/;
    return scalar reverse $dna;
}

__END__
