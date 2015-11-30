#!/usr/bin/env perl

#
# Display alignments across SAM/BAM/CRAM file formats.
#
use Bio::DB::HTS ;

use strict ;

my @test_files = (
                  'http://www.ebi.ac.uk/~rishi/test_files/small_brainz.2.bam',
                  'http://www.ebi.ac.uk/~rishi/test_files/chicken.chrZ.smallbrainz2.ens.sorted.cram'
                 ) ;

my ($hts, $hts_file, $index);

for my $f (@test_files)
{
  print("\nrn6DEBUG:AttachedFormat-BAM-file opening for $f\n") ;
  $hts = Bio::DB::HTS->new(-bam => $f);
  print("\nrn6DEBUG:AttachedFormat-BAM-file opened ".$hts->hts_path ) ;
  $hts_file = $hts->hts_file;
  print("\nrn6DEBUG:AttachedFormat-BAM-htsfile set          \n") ;
  $index = Bio::DB::HTSfile->index($hts) ;
  print("\nrn6DEBUG:AttachedFormat-BAM-file indexed         \n") ;
  my $header = $hts_file->header;
  my $region = $header->target_name->[0];
  my $callback = sub {return 1};
  print("\nrn6DEBUG:AttachedFormat-BAM-fetch calling for $region     \n") ;
  $index->fetch($hts_file, $header->parse_region("$region:1-10"), $callback);
  print("\nrn6DEBUG:AttachedFormat-BAM-fetch called for $region       \n") ;
}
