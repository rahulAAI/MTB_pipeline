#!/bin/sh
Sample=$1
samtools view -bS "$Sample".sam > bam/"$Sample".bam
samtools flagstat bam/"$Sample".bam > alignment/"$Sample".txt
samtools sort -@ 16 bam/"$Sample".bam -o "$Sample".sorted.bam

# contaminated
samtools view -b -F 4 "$Sample".sorted.bam -o "$Sample"_mapped.bam
samtools mpileup -uf genes/ref.fna "$Sample"_mapped.bam | bcftools call  -m -v -o  "$Sample".bcf
bcftools view "$Sample".bcf > vcf/"$Sample".vcf
java -jar /opt/conda/envs/myenv/share/snpeff-5.0-1/snpEff.jar -classic -t 16 h37rv  vcf/"$Sample".vcf > annotated_vcf/"$Sample".annotated.vcf
samtools mpileup -B -f genes/ref.fna "$Sample"_mapped.bam | java -jar genes/VarScan.v2.3.9.jar  pileup2snp --varinats> varscan_vcf/"$Sample"_varscan.vcf
samtools mpileup -B -f genes/ref.fna "$Sample"_mapped.bam | java -jar genes/VarScan.v2.3.9.jar  pileup2indel --varinats> varscan_vcf/"$Sample"_varscan_indel.vcf
