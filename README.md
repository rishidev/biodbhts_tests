# biodbsam_htslib_tests
Tests to use with GBrowse-Adaptors to ensure the Bio-Samtools module is working.

# Setup
You will need some repos to get this going

*htslib

*GBrowse-Adaptors
  cd 

#Test setup

Set the Perl module to be findable:
  export PERL5LIB=$PERL5LIB:/path/to/GBrowse-Adaptors/Bio-SamTools/blib/lib

Add the htslib location
  export LD_LIBRARY_PATH=/path/to/libhts.so


#Run tests
Run the test with the -I flag to make loadable object to be findable:
  perl -I /path/to/GBrowse-Adaptors/Bio-SamTools/blib/arch/auto/Bio/DB/Sam/ read5.pl









