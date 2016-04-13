use strict ;
use warnings;

use Bio::DB::HTS::VCF;
use Bio::DB::HTS::VCFSweep;

#Tests for the sweep functionality
my $sweep = Bio::DB::HTS::VCFSweep->new("data.test.vcf");
print("File opened\n");
$sweep->close() ;
print("File closed\n");
