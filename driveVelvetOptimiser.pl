#!/usr/bin/perl -w
#Need a program to drive vevlvet optimiser
#file structure
#Based on IllumiprocessorOutput
# uce-clean/taxon/split-adapter-quality-trimmeed/ (with several reads in this directory)
#Working command
#`VelvetOptimiser.pl  -d ./Abudefduf-luridus-112559/assembly/  -s 187 -e 189 -a -c ncon -f '-fastq.gz -shortPaired -separate Abudefduf-luridus-112559/split-adapter-quality-trimmed/Abudefduf-luridus-112559-READ1.fastq.gz Abudefduf-luridus-112559/split-adapter-quality-trimmed/Abudefduf-luridus-112559-READ2.fastq.gz -short Abudefduf-luridus-112559/split-adapter-quality-trimmed/Abudefduf-luridus-112559-READ-singleton.fastq.gz' -t 7`;


#taxa file, single name per line, no spaces before/after or empty lines.
#requires contigs directory where you are working
my $start=99;
my $end=145;
my $numThreads=2;
my $file=shift;

my @taxa;
open (INFILE, $file);
while(<INFILE>) {
	$line=$_;
	chomp $line;	
	push (@taxa,$line);

}
close INFILE;
#move file

#`cp ./Abudefduf-luridus-112559/assembly/contigs.fa ./contigs/Abudefduf-luridus-112559.contigs.fasta`;

#my @taxa=qw(Abudefduf-luridus-112559);

#Downsize for testing
#@taxa=@taxa[0,1,2];

foreach my $sample (@taxa) {

`VelvetOptimiser.pl  -d ./$sample/assembly/  -s $start -e $end -a -c ncon -f '-fastq.gz -shortPaired -separate $sample/split-adapter-quality-trimmed/$sample-READ1.fastq.gz $sample/split-adapter-quality-trimmed/$sample-READ2.fastq.gz -short $sample/split-adapter-quality-trimmed/$sample-READ-singleton.fastq.gz' -t $numThreads`;

`cp ./$sample/assembly/contigs.fa ./contigs/$sample.contigs.fasta`;
#added for MAC
`"yes" | rm -r auto_data_*`;

}

exit; 
