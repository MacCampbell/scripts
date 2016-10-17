#! /usr/bin/perl -w

#merge nexus files and produce a block for raxml. These nexus files have missing taxa included as all empty sequences

#expect
#NEXUS
#
#[File created from 16S.fasta using seqConverter.pl v1.2 on Thu Sep 29 20:12:33 2016]
#
#begin data;
#dimensions ntax = 36 nchar = 1718;
#format datatype = nucleotide gap = - missing = ?;
#
#matrix

#etc.

#usage
# nexusConcatter.pl 1.nexus 2.nexus 
my @numTaxa;
my @lengths;
my $ntaxa;
my $loci=@ARGV;
my @lociNames;
my %hash;

my $sep="\t";

foreach my $file (@ARGV) {
	my $name="$file";
	$name=~s/(\.nex)//;
open INFILE, "< $file" or die "Can't open $file";
my $i=0;
while (<INFILE>) {

	$i++;
	my $chars;
	my $line=$_;
	chomp $line;
	if ($line=~/^\s*dimensions/) {
	$line=~ s/^\s*// ; #removing leading tab or spaces
	my @dime=split(/\s/,$line);
        #print join ("\t", @dime);
        #$dime[1]=~s/ntax = //;
	my $taxa=$dime[3];
	push (@numTaxa,$taxa);
        #$dime[2]=~s/nchar=//;
	$dime[6]=~s/;//;
	my $length=$dime[6];
	push (@lengths,$length);
	push (@lociNames,$name.$sep.$length);

	} elsif (($i>5) && ($line ne (";" || "end;")) ) {
	#my @dat=split(/\s+/,$line);
	if ($line=~ /(^\w+)\s+([\w\-\?]+)/) {
	my $name =$1;
	my $dat=$2;
	#print $name.$sep.$dat."\n";
	$hash{$name}.=$dat;
	#print join ("\n",@dat);
	}
	}
	
	
	}

close INFILE;



}
my $alignLength=0;
for (@lengths) {
	$alignLength+=$_;
	}
#phylip file

my $filename='concat.phylip';
open (my $OUTFILE, '>', $filename) or die "Could not open outfile $filename\n";
print $OUTFILE "$numTaxa[0]\t$alignLength\n";

#should have a hash of taxa as key, and concatenated sequences as values
while (my ($k,$v)=each %hash) {
	#print length($v);
	print $OUTFILE "$k\t$v\n";
	}

close $OUTFILE;

#make raxml partition.txt
#DNA, lRNA=1-2776
#DNA, genes=2777-5863
my $sum=0;
my $end=0;

open (my $OUTFILE2, '>', 'partition.txt') or die "Could not open partition.txt\n";

foreach my $entry (@lociNames) {
	my @array=split($sep,$entry);
	$end+=$array[1];

	$sum++;
	print $OUTFILE2 "DNA, $array[0]=$sum-$end\n";
	$sum=$end;
}

close ($OUTFILE2);
exit;