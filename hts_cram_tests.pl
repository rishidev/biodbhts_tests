
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
my $fai = Bio::DB::HTS::Fai->open("data/yeast.fasta");
my $seq = $fai->fetch('X:51-1000');
my $seq_length = length $seq ;
print( "seq_length:$seq_length\n" ) ;

my $count;
while ( my $b = $hts_file->read1($header) )
{
  $count++ ;
}
print("read count:$count\n") ;
