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

my $r = 0 ;
while( $r < 5 )
{
  my $row1=$sweep->next_row();
  if( $r>0 )
  {
#    $row1->print($sweep->header);
  }
  $r++ ;
}

$r = 0 ;
while( $r < 3 )
{
  my $row1again=$sweep->previous_row();
  $row1again->print($sweep->header);
  my $chr = $row1again->chromosome($sweep->header);
  print("Chromsome from row $r:$chr\n") ;
  print("Position from row $r:".$row1again->position()."\n") ;
  print("Quality from row $r:".$row1again->quality()."\n") ;
  print("ID from row $r:".$row1again->id()."\n") ;
  print("Reference from row $r:".$row1again->reference()."\n") ;
  $r++ ;
}


#Close
$sweep->close() ;
print("File closed\n");
