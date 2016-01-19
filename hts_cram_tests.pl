
# get the figures to go with the Bio-HTS repo tests


use Bio::DB::HTS;
use Bio::DB::HTS::AlignWrapper;

my $cramfile = "data/yeast.sorted.cram";

if( $do_low_level_tests )
{
  printf("------------LOW LEVEL API-----------------\n") ;
  my $hts_file     = Bio::DB::HTSfile->open($cramfile);
  my $header  = $hts_file->header_read();

  my $targets = $header->n_targets;
  printf( "n_targets value is $targets\n" ) ;

  my $target_names = $header->target_name;
  my $target_lens = $header->target_len;
  my $num_targets = scalar @$target_names ;

  my $do_low_level_tests = 0 ;

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
  while ( my $b = $hts_file->read1($header) ) {
    $count++ ;
  }
  print("Total read count:$count\n") ;


  my @result = $header->parse_region($region);
  my $num_results = scalar @result ;
  print("$region read count:$num_results\n") ;
  foreach my $r (@result) {
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
}

print( "------- HIGH LEVEL (LOCAL FILE) ---------\n" ) ;
for my $use_fasta (1) # ( 0, 1 )
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

    my $seg = $hts->segment('I');
    print( "Segment I length ".$seg->length."\n" ) ;
    my $seq = $seg->seq;
    print( "isa Bio::PrimarySeq=".$seq->isa('Bio::PrimarySeq')."\n" );

#features - this is going wrong for CRAM, returning 2 here (but 0 below)
    print("\n\nVanilla name feature\n") ;
    my @features = $hts->features( -name => 'SRR507778.24982' ) ;
    $a = scalar @features ;
    print( "num features (vanilla,name) take 1:".$a."\n\n");



#now test the alignments fetching by location
    print("\nLocation features\n") ;
    my @alignments =
      $hts->get_features_by_location( -seq_id => 'I',
                                      -start  => 500,
                                      -end    => 20000 );
    my $num_alignments = scalar @alignments ;
    print( "get_features_by_location (take 1) num_alignments $num_alignments\n\n" ) ;



    my $qscore = scalar @{ $alignments[0]->qscore } ;
    my $dnalength = length $alignments[0]->dna ;
    print( "alignment 0 qscore ".$qscore."\n" ) ;
    print( "alignment 0 dna length ".$dnalength."\n" ) ;

# keys
#    my @keys = $alignments[5]->get_all_tags;

#    my %att = $alignments[5]->attributes;
#    print( "num attributes ".scalar( keys %att )."\n" );
#    foreach $a (sort(keys %att))
#    {
#        print $a, '=', $att{$a}, "\n";
#    }
#    print( "CIGAR:".$alignments[5]->cigar_str."\n") ;


#    my $query = $alignments[0]->query;
#    print( "".$query->start."\n" ) ;
#    print( "".$query->end."\n" ) ;
#    print( "".$query->length."\n" ) ;
#    print( "".$query->dna."\n" ) ;
#    print( "".$alignments[0]->dna."\n" ) ;
#    print( "".$alignments[0]->strand."\n" ) ;
#    print( "".$query->strand."\n" ) ;

#    my $target = $alignments[0]->target;
#    print( "target start=".$target->start."\n" ) ;
#    print( "target end=".$target->end."\n" ) ;
#    print( "target length=".$target->length."\n" ) ;
#    print( "".$target->dna."\n" ) ;
#    print( "".reversec( $alignments[0]->dna )."\n" ) ;

#    my @pads = $alignments[0]->padded_alignment;
#    $a = scalar @pads ;
#    print( "num pads".$a."\n");
#    for $a (@pads)
#    {
#      print( $a."\n" ) ;
#    }

print("----------- Opening new file handles for feature name tests --------------\n") ;
#OK this is what goes into the final test script
$hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    my @features = $hts->features( -name => 'SRR507778.24982' );
    $a = scalar @features ;
    print( "num features:".$a."\n");
#    ok( scalar @f, 2 );

$hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    @f = $hts->features(
        -filter => sub {
            my $a = shift;
            return 1 if $a->display_name eq 'SRR507778.24982';
        } );
    $a = scalar @f ;
    print( "num features:".$a."\n");
#    ok( scalar @f, 2 );

$hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    @f = $hts->features(
        -seq_id => 'XIII',
        -filter => sub {
            my $a = shift;
            return 1 if $a->display_name =~ /^SRR507778/;
        } );
    $a = scalar @f ;
    print( "num features:".$a."\n");
#    ok( scalar @f, 306 );

$hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    @f = $hts->features(
        -filter => sub {
            my $a = shift;
            return 1 if $a->display_name =~ /^SRR507778/;
        } );
    $a = scalar @f ;
    print( "num features:".$a."\n");
#    ok( scalar @f, 534 );

$hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    @f = $hts->features( -name => 'SRR507778.24982',
                         -tags => { FIRST_MATE => 1 } );
    $a = scalar @features ;
    print( "num features:".$a."\n");
#    ok( scalar @f, 1 );



#Iteration
print("----------- Iteration --------------\n") ;
    my $i =
      $hts->get_seq_stream( -seq_id => 'XIII', -start => 200, -end => 10000 );
    my $count = 0;
    while ( $i->next_seq ) { $count++ }
    print( $count."\n" );

# FH retrieval
print("----------- FH Retrieval --------------\n") ;
    my $fh = $hts->get_seq_fh( -seq_id => 'XIII', -start => 200, -end => 10000, );
    $count = 0;
    $count++ while <$fh>;
    print( $count."\n" );
    $fh->close;

$hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    $i = $hts->get_seq_stream();    # all features!
    $count = 0;
    while ( $i->next_seq ) { $count++ }
    print( $count."\n" );

$hts = Bio::DB::HTS->new(
                                 -fasta => "data/yeast.fasta",
                                 -bam          => $cramfile,
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => $use_fasta, );
    $i = $hts->get_seq_stream( -max_features => 200, -seq_id => 'XIII' );
    $count = 0;
    while ( $i->next_seq ) { $count++ }
    print( $count."\n" );
    print( $hts->last_feature_count."\n" );


    my @pairs = $hts->features( -type => 'read_pair', -seq_id => 'XIII' );
    $a = scalar @pairs ;
    print( "num features by read_pair:".$a."\n\n");


    # try coverage
    print("----------- Coverage --------------\n") ;
    my @coverage = $hts->features( -type => 'coverage', -seq_id => 'XIII' );
    my ($c) = $coverage[0]->get_tag_values('coverage');
    print( "c0 $c->[0]\n" ) ;
    print( "c1 $c->[1]\n" ) ;
    print( $coverage[0]->type."\n" );



    # test high level API version of pileup
    print("----------- Matches --------------\n") ;
    my %matches;
    my $fetch_back = sub {
        my ( $seqid, $pos, $p ) = @_;
        my $r = $hts->segment( $seqid, $pos, $pos )->dna;
        for my $pileup (@$p) {
            my $a    = $pileup->alignment;
            my $qpos = $pileup->qpos;
            my $dna  = $a->query->dna;
            my $base =
              $pileup->indel == 0 ? substr( $dna, $qpos, 1 ) :
              $pileup->indel > 0 ? '*' :
              '-';
            $matches{matched}++ if $r eq $base;
            $matches{total}++;
        }
    };

    $hts->pileup( 'XIII:1-1000', $fetch_back );
    print( "".$matches{matched}." out of ".$matches{total}."\n" );

}


print("\n\n\n-------------BAM version of tests-----------------\n") ;
my $hts = Bio::DB::HTS->new( -fasta        => "/home/rishi/coding/hts_dev/Bio-HTS/t/data/ex1.fa",
                                 -bam          => "/home/rishi/coding/hts_dev/Bio-HTS/t/data/ex1.bam",
                                 -expand_flags => 1,
                                 -autoindex    => 1,
                                 -force_refseq => 1, );

print( "file contains ".$hts->n_targets." targets\n" ) ;
my $joined_seq_ids = join $hts->seq_ids ;
print( "joined_seq_ids:".$joined_seq_ids."\n" ) ;

my @features = $hts->features( -name => 'EAS114_45:2:1:1140:1206' ) ;
$a = scalar @features ;
print( "num features:".$a."\n");


sub reversec {
    my $dna = shift;
    $dna =~ tr/gatcGATC/ctagCTAG/;
    return scalar reverse $dna;
}

__END__
