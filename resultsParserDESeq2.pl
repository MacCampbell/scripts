#! /usr/bin/perl -w

#reads in results from DESeq2 and puts them into two categories
#1 padj <0.05 && log2FoldChange > 1
#2 padj <0.05 && log2FoldChange < -1

my $i=0;
my @positiveBias;
my @negativeBias;
my @notBiased;
my @noReads;

while(<>) {
	$i++;
	if ($i==1) {
	next;
	}
	if ($i>1) {
	my $entry=$_;
	chomp $entry;
	my @line=split("\t", $entry);
	if (($line[6] eq 'NA') && ($line[2] eq 'NA')) {
	$line[0]=~s/"//g;
	push (@noReads, $line[0]);
	} elsif (($line[6] eq 'NA') && ($line[1] > 0)) {
	$line[0]=~s/"//g;
	push (@notBiased, $line[0]);
	}
	elsif (($line[6] eq 'NA') && ($line[2] > 0)) { 
	$line[0]=~s/"//g;
	push (@notBiased, $line[0]);
	}
	elsif (($line[6]<0.05) && ($line[2]>1)) {
	$line[0]=~s/"//g;
	push(@positiveBias, $line[0]);
	
	} elsif (($line[6]<0.05) && ($line[2]< -1)) {
	$line[0]=~s/"//g;
	push(@negativeBias, $line[0]);
	
	} elsif ($line[1]>0) {
	$line[0]=~s/"//g;
	push (@notBiased, $line[0]);
	
	}
	
	
	}	


}


my $posbias=@positiveBias;
my $negbias=@negativeBias;
my $imbias=@notBiased;
my $noreads=@noReads;
print "My positively biased genes count is $posbias\n";
print "My negatively biased genes count is $negbias\n";
print "My not biased genes count is $imbias\n";
print "Genes without read counts $noreads\n";

open (OUT_FH, ">posBiased.txt");
print OUT_FH join ("\n", @positiveBias);
close (OUT_FH);

open (OUT_FH, ">negBiased.txt");
print OUT_FH join ("\n", @negativeBias);
close (OUT_FH);

open (OUT_FH, ">notBiased.txt");
print OUT_FH join ("\n", @notBiased);
close (OUT_FH);
exit;