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
print("Forwards\n");
while( $r < 3 )
{
  my $row1=$sweep->next_row();
#  $row1->print($sweep->header);
  $r++ ;
}


$r = 0 ;
while( $r < 10 )
{
  my $row1again=$sweep->previous_row();
  #$row1again->print($sweep->header);

  my $chr = $row1again->chromosome($sweep->header);
  print("Chromsome:$chr\t") ;
  print("Position:".$row1again->position()."\t") ;
  print("Quality:".$row1again->quality()."\t") ;
  print("ID:".$row1again->id()."\t") ;
  print("Reference:".$row1again->reference()."\t") ;
  print("Filters(".$row1again->num_filters()."):\t") ;
  print("Alleles(".$row1again->num_alleles()."):") ;
  my $alleles_ref = $row1again->get_alleles() ;
  my @alleles = @$alleles_ref ;
  for my $a (@alleles)
  {
    print($a.",") ;
  }
  print("\n");
  $r++ ;
}


#Close
$sweep->close() ;
print("File closed\n");
