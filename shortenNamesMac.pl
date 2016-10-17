#!/usr/bin/perl -w
# shortenName.pl
# shorten the sequence names from a fasta file from GenBank to Accessions+Binomials
#From Naoki Takebayashi, modified by Mac Campbell on 2-10-2012

while (<>){
    chomp;
    unless (/^>/) {  # Not the name line
       print "$_\n";
       next;
    }

    # We are dealing with the name when the process reaches here.
    s/^>\s*//;      # get rid of '>'

    my @line = split /\s+/;

    my $first = shift (@line);  # gi|49188826|gb|CO267808.1|CO267808
    my @numbers = split /\|/, $first;

    $accNum = $numbers[3];
    $accNum =~ s/\.\d+$//;  # remove version numbers

	my $genus=shift(@line);
	my $species=shift(@line);
	#insert $accNum below to print accession numbers    
	#print ">$genus.$species.$accNum\n";
	print ">$accNum\n";
}

exit;
