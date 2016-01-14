
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
for my $c (@cov)
{
  printf($c."\n") ;
}

print( "c0:".$cov[0]."\n" ) ;
print( "c-1:".$cov[-1]."\n" ) ;
