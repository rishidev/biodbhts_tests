# script to retrieve a small piece of sequence and see what happens

use Bio::EnsEMBL::IO::Adaptor::HTSAdaptor ;
use strict ;
use warnings ;
use Bio::DB::HTS;
use Data::Dumper;

my $DEBUG = 1;
my $url = "ftp://ftp.ensembl.org/pub/release-77/bam/homo_sapiens/genebuild/GRCh38.illumina.adipose.1.bam" ;

my $chr = "17" ;
my $start = "64204817" ;
my $end = "64205728" ;
my $starti = 64204817 ;
my $endi = 64205728 ;

print "Using Bio::DB::HTS Directly\n" ;
my $hts_obj = Bio::DB::HTS->new(-bam => $url) ;
my @hts_alignments = $hts_obj->get_features_by_location(-seq_id  => $chr,
                                                 -start  => $start,
                                                 -end    => $end);
foreach my $a (@hts_alignments)
{
    # where does the alignment start in the reference sequence
    my $seqid  = $a->seq_id;
    my $start  = $a->start;
    my $end    = $a->end;
    my $strand = $a->strand;
    my $cigar  = $a->cigar_str;
    my $paired = $a->get_tag_values('PAIRED');

    # where does the alignment start in the query sequence
    my $query_start = $a->query->start;
    my $query_end   = $a->query->end;

    my $ref_dna   = $a->dna;        # reference sequence bases
    my $query_dna = $a->query->dna; # query sequence bases

    my @scores    = $a->qscore;     # per-base quality scores
    my $match_qual= $a->qual;       # quality of the match
 }
#$hts_obj->close($hts_obj->) ;



print "\nUsing ensembl-io\n" ;
my $io_adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($url);
$io_adaptor->fetch_alignments_filtered($chr, $start, $end);
$io_adaptor->htsfile_close() ;



print "\nUsing ensembl-web style - get_data\n" ;
my $web_adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($url);
my $data = $web_adaptor->fetch_alignments_filtered($chr, $start, $end) ;
$web_adaptor->htsfile_close;

print "\nUsing ensembl-web style - consensus_features\n" ;
$web_adaptor = Bio::EnsEMBL::IO::Adaptor::HTSAdaptor->new($url);
my $consensus = $web_adaptor->fetch_consensus($chr, $start, $end) ;

my $cons_lookup = {};
foreach (@$consensus)
{
  $cons_lookup->{$_->{'x'}} = $_->{'bp'};
}
$web_adaptor->htsfile_close;






print "Done - Exiting\n" ;
