#! /usr/bin/perl -w

#The goal of this program is to read in a list of SNPs that are fixed for "A" type Omy05 inds,
#and "R" type individuals
#omy05	1	AA/RR
#omy05	2	AA/RR
#omy05	3	AA/RR

#then to read in several individual genotyps
#omy05	1	AA	AA	AR	AR	RR
#omy05	2	AA	AA	AR	AR	RR
#omy05	3	AA	AA	AR	AR	RR

#steps
#AA n=9
#M013781.sorted.bam
#M013782.sorted.bam
#M026851.sorted.bam
#M026868.sorted.bam
#M067945.sorted.bam
#M067954.sorted.bam
#M075219.sorted.bam
#M075268.sorted.bam
#M083418.sorted.bam
#RR n=9
#M024389.sorted.bam
#M027288.sorted.bam
#M027304.sorted.bam
#M057389.sorted.bam
#M075289.sorted.bam
#M075304.sorted.bam
#M079616.sorted.bam
#M079632.sorted.bam
#M083417.sorted.bam

#Extract omy05 info
#$for f in *.sorted.bam; do echo $f; samtools view -b $f omy05 > ./omy05/$f; done;

#Call genotypes (as freqs and bases
#angsd -bam pop -out genotypes -doSaf 1 -doPost 2 -GL 2 -doMaf 2 -doMajorMinor 1 -minMaf 0.05 -minInd 15 -minMapQ 30 -minQ 30 -SNP_pval 2e-3 -anc ~/data/OmyGenomeV06/omyV6Chr.fasta -postCutoff 0.95 -doGeno 2 > out 2> err &
#angsd -bam pop -out genoBases -doSaf 1 -doPost 2 -GL 2 -doMaf 2 -doMajorMinor 1 -minMaf 0.05 -minInd 15 -minMapQ 30 -minQ 30 -SNP_pval 2e-3 -anc ~/data/OmyGenomeV06/omyV6Chr.fasta -postCutoff 0.95 -doGeno 4 > out4 2> err4 &


#prepare genotype file
#$gunzip -c genotypes.geno.gz | cut -f 1-20 > out.geno

#run findSnpsWithinAndBetween.R
#get output 
#snpsFixedBetweenPopsSites.txt 
#12
#14

#usage
#./haplotyperOmy05.pl genotypes.txt  genosToTest.txt
#genotypes.txt 
#12	AA	GG
#14	CC	TT
#made it like so
#gunzip -c genoBases.geno.gz | cut -f 1-20 > genoBases.txt
#cat snpsFixedBetweenPopsSites.txt | cut -f 2 | while read line; do grep $line genoBases.txt >> test.txt; done;
#check to make sure grep doesn't get numbers we don't want grep 23 could get 23000 230 etc
#cut -f 2,3,15 test.txt > genotypes.txt
#head genotypes.txt 
#27211663	AA	TT
#28500582	TT	GG

#genosToTest.txt a list of genos to test!
#12	AA	GG
#14	CC	TT
#cut -f 2-20  genoBases.txt > genosToTest.txt 

#finds sites within genotypes.txt, defines AA/RR types, and then checks out genos to test!
my $sep="\t";
my $genoFile=shift;
my $testFile=shift;
my $testSize;
my %sites;

open (INFILE, "<$genoFile") || die "Can't open $genoFile\n";
	while(<INFILE>) {
    chomp;
    next if (/^$/);            # skip empty line
	my @line = split(/\t/, $_);
	$sites{$line[0]}=$line[1].$sep.$line[2];

}	

close(INFILE);

#determine sample size
open (INFILE, "<$testFile") || die "Can't open $testFile\n";
	while(<INFILE>) {
    chomp;
    next if (/^$/);            # skip empty line
	my @line = split(/\t/, $_);
	$testSize=$#line;
	#since first position is site, and zero referenced, this seems to be fine.
}	

close(INFILE);

print "examining $testSize samples\n";
print "samples\tNumberAA\tNumberAR\tNumberRR\n";
for (my $i=1; $i<=$testSize; $i++) {
my $Agenos=0;
my $Rgenos=0;
my $ARgenos=0;

my %tests;
open (INFILE, "<$testFile") || die "Can't open $testFile\n";
	while(<INFILE>) {
    chomp;
    next if (/^$/);            # skip empty line
	my @line = split(/\t/, $_);
	$tests{$line[0]}=$line[$i];

}	

close(INFILE);

my @keys = keys %sites;
    for my $key (@keys) {
      #get AA/RR refs
      my @a= split($sep, $sites{$key});
      my @aa=split(//, $a[0]);
      my @rr=split(//, $a[1]);
      my $a=$aa[0];
      my $r=$rr[0];
      if (exists $tests{$key}) {
      my @genos=split(//, $tests{$key});
      my $aCntr;
      my $rCntr;
      if (($a eq $genos[0]) && ($a eq $genos[1])) {
      	$aCntr+=2;
      	$rCntr=0;
      	$Agenos++;
      } elsif (($r eq $genos[0]) && ($r eq $genos[1])) {
        $aCntr=0;
        $rCntr+=2;
        $Rgenos++;
      } elsif ((($a eq $genos[0]) && ($r eq $genos[1])) || (($r eq $genos[0]) && ($a eq $genos[1]))) {
      	$aCntr++; $rCntr++;
      	$ARgenos++;
      } elsif ( ($genos[0] eq "N") && ($genos[1] eq "N")) {
      $aCntr=0;
      $rCntr=0;
      } else {
      print "you have a snp at site $key that isn't as decisive as your think\n";
      	$aCntr="NA";
      	$rCntr="NA";
      }
      
      }
      
      
        #print "The sites of '$fruit' is $tests{$fruit}\n";
 }


print "individual $i\t$Agenos\t$ARgenos\t$Rgenos\n";

}


#print "\n";


