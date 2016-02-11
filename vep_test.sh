#designed to be run after the install of the VEP
#clone alongside ensembl-tools, cd and run from there
#when installing vep put human grch38 cache in and the human sequence

#test1 checks the faidx
#test2 more general stuff

cd ../ensembl-tools/script/variant_effect_predictor
export LD_LIBRARY_PATH=$PWD/htslib:$LD_LIBRARY_PATH
perl variant_effect_predictor.pl --check_ref -i example_chr22_400xxxxx.vcf --force_overwrite --cache -o test1
perl variant_effect_predictor.pl -i example_GRCh38.vcf --offline --hgvs --fasta ~/.vep/homo_sapiens/80_GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --force_overwrite - o test2
cd -
