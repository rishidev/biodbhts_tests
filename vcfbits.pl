use strict ;
use warnings;

use Bio::DB::HTS::VCF;

#Tests for the sweep functionality
#Open the file
my $sweep = Bio::DB::HTS::VCFSweep->new(filename => "data/test.vcf.gz");
print("File opened\n");

#Display contents
print("Header\n");
print($sweep->header."\n");

my $row1=$sweep->next_row();
my $row2=$sweep->next_row();
my $row1again=$sweep->previous_row();

#Close
$sweep->close() ;
print("File closed\n");


