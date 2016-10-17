# scripts
A collection of scripts I have been using for analysis. The goal is to make scripts I use available in one location for me and others as a citable repository.

Perl scripts I have written draw heavily from Naoki Takebayashi's scripts and instruction: http://raven.iab.alaska.edu/~ntakebay/teaching/programming/perl-scripts/perl-scripts.html

## computeTriplets.pl
Associated Paper: See https://www.ncbi.nlm.nih.gov/pubmed/24582736

This script will read in tree files and a list of taxa and tell you how many times the taxa are related to each other. It is designed for a rooted three taxon case, a triplet analyis.

## degSeqParser.pl
Associated Paper: In prep

A simple script to filter the output from DEGseq (not DESeq) by Story's Q value <0.05 and abs(log2 fold change) > 1.

## driveVelvetOptimiser.pl
Associated Paper: In prep

This script automates VelvetOptimiser.pl to work through a list of taxa and a range of kmer values with a certain number of processors. The output works on files organized from the output from PHYLUCE pipeline, Illumiprocessor.

## extractVariableSitesByCodonPosition.pl
Associated Paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4458374/ used an earlier version of the script.

This script removes the variable sites from an alignment and generates variable sites for 1st, 2nd, and 3rd codon positions.

## genomeSplitter.pl
Associated Paper: In prep

Reads in large sequences and splits them up inter smaller sequences, e.g. chromosomes into 10000bp bits. 

## haplotyperOmy05.pl
Associated Paper: In prep

Compares diagnostic SNP sites to called genotypes to identify observed haplotypes. Designed for identifying inversion types in steelhead.

## locateSeqs.pl
Associated Paper: In prep

This script uses blastn to locate sequences of interest from a fasta formatted file onto reference sequences. In my case, that is the rainbow trout genome. Criteria such as evalue, alignment length and percent identity can be modified.

## nexusConcatter.pl
Associated Paper: In prep

A way to concatenate several nexus files into a single phylip file with a partition file formatted for RAxML. I have several types of these, this will work with output from seqConverter.pl
Can use like ./nexusConcatter.pl *.nex

## removeCodonPositions3RY.pl
Associated Paper: In prep

Assuming an aligned fasta file where the sequences are organized by codon positions starting with 1 (123123123, etc.), this script removes third codon positions entirely or recodes them as purines or pyrimidines (R/Y).
The output is now 111222 or 111222333 in terms of codon positions.

## resultsParserDESeq2.pl
Associated Paper: In prep

For further refinement of DESeq2 output. If you set your alpha to 0.05 with DESeq2, then as is should be fine. Filters for padj <0.05 && abs(log2FoldChange) > 1

## shortenNamesMac.pl
Associated Paper: In prep

A simple script to parse downloaded fasta formatted sequence names into more usable formats.

