#!/usr/bin/perl -w

#3/2/2016
#The goal is to read in a fasta file of genomes, and plit it into 10KB peices
#Such as, >Tr0_chr1
#>Tr0_chr1.1
#seq of 10 kbp
#>Tr0_chr1.2
#seq of 10 kbp

my $sep = "\t";
my $dnaFile = shift; 
my @dat = ReadInFASTA($dnaFile);
my @names = TaxaNames(@dat);
my @seqDat =  GetSeqDat(@dat);  # just extract sequence part

# @names would be chromosome name


foreach my $i (0..$#names) {
	my @array=unpack '(a10000)*', $seqDat[$i];
	my $j=0;
	foreach my $entry (@array) {
	$j++;
	print ">$names[$i].$j\n";
	print $entry;
	print "\n";
	
	}

}

exit;

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
        die ("ERROR: \"$sep\" is an internal se        }parator.  Line $. of " .
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
sub TaxaNames {
    my @data = @_;
    my @line;
    my @result = ();

    foreach my $i (@data) {
	#print join ("\n", split (/$sep/, $i)), "\n";         
	@line = split (/$sep/, $i);
        push @result, $line[0];
    }


    return (@result)
}
