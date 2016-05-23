
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

void print_vcf_row(const bcf1_t* row, const bcf_hdr_t* h) ;

int main()
{
  printf("Testing HTSlib in C\n") ;

  /* vcf bits with format */
  htsFile* fp = bcf_open("data/test.vcf.gz", "r");
  bcf_hdr_t* h1 = bcf_hdr_read(fp);
  bcf1_t* rec = bcf_init();
  if ( bcf_read(fp, h1, rec) == 0 )
  {
    bcf_unpack(rec, BCF_UN_ALL) ;
  }
  printf("chromosome:%s\n", bcf_hdr_id2name(h1,rec->rid));
  if ( bcf_read(fp, h1, rec) == 0 )
  {
    bcf_unpack(rec, BCF_UN_ALL) ;
  }

  printf("chromosome:%s\n", bcf_hdr_id2name(h1,rec->rid));
  if ( bcf_read(fp, h1, rec) == 0 )
  {
    bcf_unpack(rec, BCF_UN_ALL) ;
  }
  printf("chromosome:%s\n", bcf_hdr_id2name(h1,rec->rid));
  bcf_fmt_t* fmt = bcf_get_fmt(h1, rec, "DP");
  int32_t* buf_i = calloc(fmt->n, sizeof(int32_t));
  int result = bcf_get_format_int32(h1, rec, "DP", &buf_i, &(fmt->n)) ;
  printf("rn6DEBUG:int8 format result %d for size %d\n",result,fmt->n) ;



  /* Mimic Sweep open close */
  bcf_sweep_t* sweep = bcf_sweep_init("data/test.vcf.gz") ;
  bcf_hdr_t* h = bcf_sweep_hdr(sweep);
  bcf1_t* row ;

  for( int r=0 ; r<5 ; r++ )
  {
    //printf( "Forwards Line %d\t", r ) ;
    row = bcf_sweep_fwd(sweep);
    //print_vcf_row(row,h);
  }

  for( int r=0 ; r<5 ; r++ )
  {
    printf( "Backwards Line %d\t", r ) ;
    row = bcf_sweep_bwd(sweep);
    print_vcf_row(row,h);
  }

  bcf_sweep_destroy(sweep) ;

  // The read method of getting a row


  return 0 ;
}


void print_vcf_row(const bcf1_t* row, const bcf_hdr_t* h)
{
  char* chr = bcf_hdr_id2name(h,row->rid) ;
  printf("Chromsome:%s\t", chr) ;
  printf("Position:%d\t", row->pos+1) ;
  printf("Quality:%f\t", row->qual) ;
  printf("ID:%s\t", row->d.id ) ;
  printf("Reference:%s\t", row->d.als) ;
  printf("Filters(%d):\t", row->d.n_flt) ;
  printf("Alleles:(%d):", row->n_allele-1) ;
  for (int i = 1; i < row->n_allele; ++i)
  {
    printf("%s,",row->d.allele[i]);
  }

  //print info fields
  bcf_info_t* info = bcf_get_info(h, row, "NS");
  printf("\tINFO:") ;
  if( info == NULL )
  {
    printf( "NULL\t" ) ;
  }
  else
  {
    printf( "len=%d,type=%d,value=%hhd\t", info->len, info->type, info->v1.i ) ;
  }

  printf("\n");
}
