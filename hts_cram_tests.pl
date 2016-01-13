
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
