#! /usr/bin/perl -w
#Assumes that the input fasta is aligned such that the first base in the
#file is in the first position.
#05/13/2013 creating two files
#12.fasta
#123RY.fasta


my $sep = "\t";
my $dnaFile = shift; 
my @dat = ReadInFASTA($dnaFile);
my @names = TaxaNames(@dat);
my @seqDat =  GetSeqDat(@dat);  # just extract sequence part



my @firstPositions = Position1(@seqDat);
#print join ("\n", @firstPositions);
my @secondPositions = Position2(@seqDat);
my @thirdPositions = Position3(@seqDat);

#sub RY
foreach my $thirdSeq (@thirdPositions) {
	$thirdSeq=~ s/[AG]/R/g;
	$thirdSeq=~ s/[CT]/Y/g;
}

#Combining names and files
foreach my $i (0..$#names) {
        $oneTwo[$i] = $names[$i] . "\n" . $firstPositions[$i] . $secondPositions[$i] ;
    }
foreach my $i (0..$#names) {
        $oneTwoThreeRY[$i] = $names[$i] . "\n" . $firstPositions[$i] . $secondPositions[$i] . $thirdPositions[$i] ;
    }

#
#Printing to separate outfiles 12 and 123RY

open (OUT_FH, ">12.$dnaFile");
print OUT_FH ">";
print OUT_FH join ("\n>", @oneTwo), "\n";
      close (OUT_FH);

open (OUT_FH, ">123RY.$dnaFile");
print OUT_FH ">";
print OUT_FH join ("\n>", @oneTwoThreeRY), "\n";
      close (OUT_FH);



exit;

sub Position1 {
my @result=();
my @data = @_; 
# print join ("\n", @data), "\n"; # Is dat in sub Positions?
	foreach $sequence (@data) {
		#print "The sequence:\n$sequence\n"; #Is foreach processing each element of the array?
		my $n=0;		
		#my $first = substr $sequence, 0, 3;
		#print "$first\n";
		my @splitSequence=split(//, $sequence);	
			my @arr2 = grep{!($n++ % 3)} @splitSequence;
			#print "These are first (of $n total bases) positions:\n@arr2\n";
	 	my $firstBases= join ('', @arr2);
		#print "A string of firstcodon positions:$firstBases\n";
		push (@result, $firstBases);
	}

return (@result)
}

sub Position2 {
my @result=();
my @data = @_; 
# print join ("\n", @data), "\n"; # Is dat in sub Positions?
	foreach $sequence (@data) {
		#print "The sequence:\n$sequence\n"; #Is foreach processing each element of the array?
		my $n=2;		
		my @splitSequence=split(//, $sequence);	
			my @arr2 = grep{!($n++ % 3)} @splitSequence;
			#print "The second positions:\n@arr2\n";
	 	my $firstBases= join ('', @arr2);
		push (@result, $firstBases);
	}

return (@result)
}

sub Position3 {
my @result=();
my @data = @_; 
# print join ("\n", @data), "\n"; # Is dat in sub Positions?
	foreach $sequence (@data) {
		#print "The sequence:\n$sequence\n"; #Is foreach processing each element of the array?
		my $n=1;		
		my @splitSequence=split(//, $sequence);	
			my @arr2 = grep{!($n++ % 3)} @splitSequence;
			#print "The third positions:\n@arr2\n";
	 	my $firstBases= join ('', @arr2);
		push (@result, $firstBases);
	}

return (@result)
}


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
