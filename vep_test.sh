#designed to be run after the install of the VEP
#clone alongside ensembl-tools, cd and run from there
#when installing vep put human grch38 cache in and the human sequence

#test1 checks the faidx
#test2 more general stuff

cd ../ensembl-tools/scripts/variant_effect_predictor

#export LD_LIBRARY_PATH=$PWD/htslib
#$PWD/biodbhts/blib/arch/auto/Bio/DB/HTS:$PWD/biodbhts/blib/arch/auto/Bio/DB/HTS/Faidx
#export PERL5LIB=/home/rishi/perl5/lib/perl5:$PWD/biodbhts/blib/arch/auto/

export LD_LIBRARY_PATH=
export PERL5LIB=

echo $LD_LIBRARY_PATH
echo $PERL5LIB
echo $PATH
echo
echo TEST 1
perl variant_effect_predictor.pl --check_ref -i example_GRCh38.vcf --force_overwrite --cache -o test1
echo
echo
echo TEST 2
perl variant_effect_predictor.pl -i example_GRCh38.vcf --offline --hgvs --fasta ~/.vep/homo_sapiens/83_GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --force_overwrite - o test2
echo
cd -

echo TEST 3
perl ../ensembl-tools/scripts/variant_effect_predictor/variant_effect_predictor.pl --check_ref -i ../ensembl-tools/scripts/variant_effect_predictor/example_GRCh38.vcf --force_overwrite --cache -o test3
echo
echo
echo TEST 4
perl ../ensembl-tools/scripts/variant_effect_predictor/variant_effect_predictor.pl -i ../ensembl-tools/scripts/variant_effect_predictor/example_GRCh38.vcf --offline --hgvs --fasta ~/.vep/homo_sapiens/83_GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --force_overwrite -o test4


