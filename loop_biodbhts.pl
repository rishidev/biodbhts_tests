use strict;
use warnings;
use 5.10.1;
use Data::Dumper;

require Bio::DB::HTS;
use Bio::EnsEMBL::IO::Adaptor::HTSAdaptor;

my $num_loops=10 ;
my $sleep_time=1 ;

if( $ARGV[0] )
{
  $num_loops = $ARGV[0] ;
}

if( $ARGV[1] )
{
  $sleep_time = $ARGV[1] ;
}

my $url = 'ftp://ftp.ensembl.org/pub/release-77/bam/homo_sapiens/genebuild/GRCh38.illumina.adipose.1.bam';

for(my $i=0;$i<=$num_loops;$i++)
{
  say $i;
  my $url      = 'ftp://ftp.ensembl.org/pub/release-77/bam/homo_sapiens/genebuild/GRCh38.illumina.adipose.1.bam';
  my $hts      = Bio::DB::HTS->new( -bam => $url);
  my $hts_file = $hts->hts_file;
  my $index    = Bio::DB::HTSfile->index($hts);
  my $header   = $hts->header;
  my $region   = $header->target_name->[0];
  say $hts_file;
  say $index;
  say $region;
  say "\n";

  if( $sleep_time > 0 )
  {
    sleep $sleep_time ;
  }
}
