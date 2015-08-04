# biodbsam_htslib_tests
Tests to use with GBrowse-Adaptors to ensure the Bio-Samtools module is working.

## Setup
You will need some repos to get this going:  
### htslib [http://htslib.org]  
`git clone https://github.com/samtools/htslib.git`  
`cd htslib`  
`make`

### Bio-HTS
(dev at the moment)  
`git clone https://github.com/rishidev/Bio-HTS`
`cd Bio-HTS`  
`perl Build.pl`  
You will need to enter the htslib location when you type the following command.
`./Build`  

## Test setup
Set the Perl module to be findable:  
`export PERL5LIB=$PERL5LIB:/path/to/Bio-HTS/blib/lib`  
Add the htslib location
`export LD_LIBRARY_PATH=/path/to/htslib/libhts.so`


## Run tests
Run the test with the -I flag to make loadable object to be findable:  
`perl -I /path/to/Bio-HTS/blib/arch/auto/Bio/DB/HTS read5.pl`

