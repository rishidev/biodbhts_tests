# Copyright [1999-2016] EMBL-European Bioinformatics Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use Bio::EnsEMBL::IO::Parser::VCF4Tabix ;
use Bio::EnsEMBL::IO::Parser::PairwiseTabix ;

my @tfiles = (
 'ftp://ftp.ensembl.org/pub/variation_genotype/mus_musculus/mgp.v3.indels.sorted.rsIDdbSNPv137.vcf.gz',
 'http://vizhub.wustl.edu/hubSample/hg19/K562POL2.gz',
) ;

for my $test_file (@tfiles)
{
  print "starting tests on $test_file\n" ;
  print "Bio::EnsEMBL::IO::Parser::PairwiseTabix\n" ;
  my $t1 = Bio::EnsEMBL::IO::Parser::PairwiseTabix->open($test_file) ;

  print "Bio::EnsEMBL::IO::Parser::VCF4Tabix\n" ;
  my $t2 = Bio::EnsEMBL::IO::Parser::VCF4Tabix->open($test_file) ;

  print "Bio::EnsEMBL::IO::Parser::open_as(PairwiseTabix,..)\n" ;
  my $t3 = Bio::EnsEMBL::IO::Parser::open_as('PairwiseTabix', $test_file);
}
