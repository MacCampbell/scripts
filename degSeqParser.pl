#! /usr/bin/perl -w



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
	#first pos biased
	if  (($line[1] && $line [2]) eq "NA" ) {
		push (@noReads, $line[0]);
	} elsif ((($line[4] || $line[8]) eq "NA") && (($line[1] || $line [2])=~/\d?/)) {
		push (@notBiased, $line[0]);
	}
	elsif (($line[4] || $line[8]) eq "NA") {
		push (@noReads, $line[0]);
	} elsif (($line[4] > 1) && ($line[8] < 0.05)) {
		push (@positiveBias, $line[0]);
	} elsif (($line[4] < -1) && ($line[8] < 0.05)) {
		push (@negativeBias, $line[0]);
	} else {
		push (@notBiased, $line[0]);
	}
	
	
	
	}	


}


my $posbias=@positiveBias;
my $negbias=@negativeBias;
my $imbias=@notBiased;
my $noreads=@noReads;
my $tot=$posbias+$negbias+$imbias+$noreads;

print "My positively biased genes count is $posbias\n";
print "My negatively biased genes count is $negbias\n";
print "My not biased genes count is $imbias\n";
print "Genes without read counts $noreads\n";
print "total gene models:\t$tot\n";

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

exit;