
#include <stdio.h>

#include <unistd.h>
#include <math.h>
#include <string.h>
#include "kseq.h"
#include "hts.h"
#include "sam.h"
#include "khash.h"
#include "faidx.h"
#include "tbx.h"
#include "bgzf.h"
#include "vcf.h"
#include "vcfutils.h"
#include "vcf_sweep.h"
#include "synced_bcf_reader.h"

/*
 Compile with:
gcc -I $HTSLIB_DIR/htslib -D_IOLIB=2 -D_FILE_OFFSET_BITS=64 -o vcf.exe vcf.c -Wl,-rpath,$HTSLIB_DIR  -L$HTSLIB_DIR -lhts -lz -lpthread

*/

int main()
{
  printf("Testing HTSlib in C\n") ;

  /* Mimic Sweep open close */
  bcf_sweep_t* sweep = bcf_sweep_init("data/test.vcf.gz") ;

  bcf_sweep_destroy(sweep) ;
  return 0 ;
}
