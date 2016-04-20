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
print( "row1:");
$row1->print($sweep->header);

my $row2=$sweep->next_row();
print( "row2:");
$row2->print($sweep->header);

my $row1again=$sweep->previous_row();
print("row1again:");
$row1again->print($sweep->header);

my $row2again=$sweep->previous_row();
print("row2again:");
$row2again->print($sweep->header);

#Close
$sweep->close() ;
print("File closed\n");


