#!/usr/bin/perl -w

#Makes fasta files of variable sites from an alignment based on codon positions

#Step 1: Import a fasta file

my $sep = "\t";
my $dnaFile = shift; 
my @dat = ReadInFASTA($dnaFile);
my @names = TaxaNames(@dat);
my @seqDat =  GetSeqDat(@dat);  # just extract sequence part

#Step 2: Split into codon positions

my @firstPositions = Position1(@seqDat);
my @secondPositions = Position2(@seqDat);
my @thirdPositions = Position3(@seqDat);
#Find Variable Sites
my @firstVar = VariableSites(@firstPositions);
my @secondVar = VariableSites(@secondPositions);
my @thirdVar = VariableSites(@thirdPositions);

#print "first sites @firstVar\n";
#print "second sites @secondVar\n";
#print "third @thirdVar\n";

# checks out!
# Extract from seqs


my @finalFirstSeq=();
foreach my $seq (@firstPositions) {
	my @varDat=();
	my @dat=split(//, $seq);
	foreach my $number (@firstVar) {
		push @varDat, $dat[$number]; 
	}
	my $vars=join ("",@varDat);
	push (@finalFirstSeq, $vars);
}
foreach my $i (0..$#names) {
        $firstNames[$i] = $names[$i]."\n".$finalFirstSeq[$i];
    }
#print "These are first positions\n";
open (OUT_FH, ">1stPositions.fasta");
print OUT_FH ">";
print OUT_FH join ("\n>", @firstNames), "\n";
      close (OUT_FH);

my @finalSecondSeq=();
foreach my $seq (@secondPositions) {
	my @varDat=();
	my @dat=split(//, $seq);
	foreach my $number (@secondVar) {
		push @varDat, $dat[$number]; 
	}
	my $vars=join ("",@varDat);
	push (@finalSecondSeq, $vars);
}
foreach my $i (0..$#names) {
        $secondNames[$i] = $names[$i]."\n".$finalSecondSeq[$i];
    }
#print "These are first positions\n";
open (OUT_FH, ">2ndPositions.fasta");
print OUT_FH ">";
print OUT_FH join ("\n>", @secondNames), "\n";
      close (OUT_FH);

my @finalThirdSeq=();
foreach my $seq (@thirdPositions) {
	my @varDat=();
	my @dat=split(//, $seq);
	foreach my $number (@thirdVar) {
		push @varDat, $dat[$number]; 
	}
	my $vars=join ("",@varDat);
	push (@finalThirdSeq, $vars);
}
foreach my $i (0..$#names) {
        $thirdNames[$i] = $names[$i]."\n".$finalThirdSeq[$i];
    }
#print "These are first positions\n";
open (OUT_FH, ">3rdPositions.fasta");
print OUT_FH ">";
print OUT_FH join ("\n>", @thirdNames), "\n";
      close (OUT_FH);

exit;




sub VariableSites {
	my @data=@_;
	my @seqs=();
	my $length;
	my $numSamples=$#data;	
	foreach my $sequence (@data) {
		my @seq=split (//, $sequence);
		push @seqs, [@seq];
		$length=$#seq; #Need a length, so here it is.	
	}
		
#Now we have an array of arrays @seqs;
	my @varSites;	
	for ($i=0; $i<$numSamples; $i++) {
		for ($j=0; $j<=$length; $j++) {
		my $site1 = $seqs[$i][$j];
		my $site2 = $seqs[$i+1][$j];	
		#if (($site1 || $site2) eq "-") { 
		#print "Found - \n";	
		#next;	
		#}	
		if ($site1 eq $site2) {
		next;
		}
		if (($site1 ne $site2) && (($site1 ne "-" ) && ($site2 ne "-"))) {
		push (@varSites, $j);
		} 
	}
	}
# This returns nonunique values for whatever reason....
# Cleaning up;
my %unique=();
	foreach (@varSites){
	$unique{$_}=1;
	}
	my @result=keys %unique;
	@result =sort @result;
return (@result);
}




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









