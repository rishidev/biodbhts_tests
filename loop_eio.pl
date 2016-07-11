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

my $hts_adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($url);

for(my $i=0;$i<=$num_loops;$i++)
{
  say $i;
  my $hts_file = $hts_adaptor->htsfile_open;
  say "\n";
#  $hts_file->close;
  if( $sleep_time > 0 )
  {
    sleep $sleep_time ;
  }
}
