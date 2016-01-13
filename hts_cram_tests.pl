
# get the figures to go with the Bio-HTS repo tests


use Bio::DB::HTS;
use Bio::DB::HTS::AlignWrapper;

my $cramfile = "$Bin/data/yeast.cram";
my $hts_file     = Bio::DB::HTSfile->open($cramfile);
my $header  = $hts_file->header_read();
my $targets = $header->n_targets;
printf( "n_targets value is $targets\n" ) ;
