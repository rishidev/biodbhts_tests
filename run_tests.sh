export PERL5LIB=/home/rishi/coding/hts_dev/Bio-DB-HTS/lib
export LD_LIBRARY_PATH=/home/rishi/coding/hts_dev/htslib

perl -I /home/rishi/coding/hts_dev/Bio-DB-HTS/blib/arch/auto/Bio/DB/HTS read5.pl
perl -I /home/rishi/coding/hts_dev/Bio-DB-HTS/blib/arch/auto/Bio/DB/HTS display_alignments.pl
perl -I /home/rishi/coding/hts_dev/Bio-DB-HTS/blib/arch/auto/Bio/DB/HTS get_features.pl
