#! /usr/bin/perl -w
#Written by Mac Campbell, drmaccampbell@gmail.com 
#10/28/2016

#Goal read in a fasta file
#Place those sequences on a chromosome
#output 
# 1. Number of significant hits and any that pass thresholds defined at line 61.
# 2. Any sequences without matches at e-value specified.
# 3. A table of position on that chromosome for each seq.
#this script uses blastn and a blast database. Make your blast db and point to it
#change lines 21/22 as needed. 
#makeblastdb -in omy05.fasta  -out omy05.db -dbtype 'nucl'

#read in fasta -> note, if there are sites in sequence like this [C/T] use sub biIUPAC to clean it up
#you can use shortenNamesMac.pl to shorten names to Accessions to make this easier.
#usage locateMsats.pl fastaFile.fasta
#requires blastn to be in your path

my $fasta=shift;
#my $db=shift;
my $db="~/omy06/combinedRef"; # I hard linked it, I know I'm a terrible person.

my $sep = "\t";

my @dat = ReadInFASTA($fasta);

my @cleanDat = biIUPAC (@dat);
my @noReturns;
my @goodReturns;
my @blast;

foreach my $seq (@cleanDat) {
	my @sequence=split("\t",$seq);
	#print $sequence[1]."\n";
	$seq = ">".$seq;
	$seq =~ s/\t/\n/;
	my $out;
	open (my $outfile, '>', 'temp.fasta');
	print $outfile $seq;
	print $outfile "\n";
	close $outfile;
	$out=`blastn -query temp.fasta -db $db -evalue .001 -outfmt 6 -max_target_seqs 1`;
	` "yes" | rm temp.fasta`;
	#print "printing out\n";
	#print "$out";
	#need to get the first hit -max_target_seqs 1 is the option for outfmt > 4
	my @output=split("\n",$out);
	if ($#output >= 0) {
	my $num=$#output+1;
	print "$sequence[0]\tfound hit(s):\t".$num."\n";
	foreach my $hit (@output) {
	my @sequenceBases=split(//,$sequence[1]);
	my $thresh=$#sequenceBases+1;
	#print "my thresh is $thresh\n";
	my @splitOut=split(/\t/,$hit);
	if (($splitOut[3]>(0.95*($thresh))) && ($splitOut[2]>95) ) {
	print $hit."\n";
	push (@goodReturns,$sequence[0]);
	} else {
	next;
	}
	
	}
	}
#	print "My output is:\n $output[0]\n";
	if (exists $output[0]) {
	push (@blast, $output[0]."\n");
	} else {
	push (@noReturns,$sequence[0]);
	}

}
print "The folowing sequence(s) did not have a significant match to target sequence with evalue of 0.001\n";
print join ("\n", @noReturns);
print "\n";
print "\n";


#Need to rank in order, some sequences orientation are -,
#Need to print summary table

foreach my $return (@blast) {
	my @a=split("\t", $return);
	if ($a[8] < $a[9]) {
		next; 
		}
	elsif ($a[8] > $a[9]) {
	my $start=$a[8];
	my $end=$a[9];
	$a[8]=$end;
	$a[9]=$start;
	$return=join ("\t",@a);
	}
print $return;

}


exit;

sub biIUPAC {
	my @a=@_;
	foreach my $seq (@a) {
	#should be biallelic
	$seq =~ s/\[A\/C\]/M/g;
	$seq =~ s/\[C\/A\]/M/g;

	$seq =~ s/\[A\/G\]/R/g;
	$seq =~ s/\[G\/A\]/R/g;

	$seq =~ s/\[A\/T\]/W/g;
	$seq =~ s/\[T\/A\]/W/g;

	$seq =~ s/\[C\/G\]/S/g;
	$seq =~ s/\[G\/C\]/S/g;
	
	$seq =~ s/\[C\/T\]/Y/g;
	$seq =~ s/\[T\/C\]/Y/g;

	$seq =~ s/\[G\/T\]/K/g;
	$seq =~ s/\[T\/G\]/Y/g;

	}
return (@a)



}

#These sub routines are from Naoki Takebayashi: http://raven.iab.alaska.edu/~ntakebay/teaching/programming/perl-scripts/perl-scripts.html

sub ReadInFASTA {
    my $infile = shift;
    my @line;
    my $i = -1;
    my @result = ();
    my @seqName = ();
    my @seqDat = ();

    open (INFILE, "<$infile") || die "Can't open $infile\n";

    while (<INFILE>) {
        chomp;
        if (/^>/) {  # name line in fasta format
            $i++;
            s/^>\s*//; s/^\s+//; s/\s+$//;
            $seqName[$i] = $_;
            $seqDat[$i] = "";
        } else {
            s/^\s+//; s/\s+$//;
	    s/\s+//g;                  # get rid of any spaces
            next if (/^$/);            # skip empty line
            s/[uU]/T/g;                  # change U to T
            $seqDat[$i] = $seqDat[$i] . uc($_);
        }

	# checking no occurence of internal separator $sep.
	die ("ERROR: \"$sep\" is an internal separator.  Line $. of " .
	     "the input FASTA file contains this charcter. Make sure this " . 
	     "separator character is not used in your data file or modify " .
	     "variable \$sep in this script to some other character.\n")
	    if (/$sep/);

    }
    close(INFILE);

    foreach my $i (0..$#seqName) {
	$result[$i] = $seqName[$i] . $sep . $seqDat[$i];
    }
    return (@result);
}

sub GetSeqDat {
    my @data = @_;
    my @line;
    my @result = ();

    foreach my $i (@data) {
	@line = split (/$sep/, $i);
	push @result, $line[1];
    }

    return (@result)
}

sub GetSeqName {
    my @data = @_;
    my @line;
    my @result = ();

    foreach my $i (@data) {
	@line = split (/$sep/, $i);
	push @result, $line[0];
    }
    return (@result)
}




