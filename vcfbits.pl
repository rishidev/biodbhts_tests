use strict ;
use warnings;

use Bio::DB::HTS::VCF;

#Tests for the sweep functionality
my $sweep = Bio::DB::HTS::VCFSweep->new(filename => "data/test.vcf");
print("File opened\n");
$sweep->close() ;
print("File closed\n");


