#! /usr/bin/perl -w
use Bio::TreeIO;
#!Uses Bioperl!

#written by Mac Campbell macampbell2@alaska.edu
#computes frequencies of rooted three taxa cases (triplet analysis).
#usage: computeTriplets.pl treeFile taxaFile 2>err (to catch error)
#treefile is a set of unrooted trees (one per line) in newick format
#ex:
#(((((tx1,tx3),tx2),(tx4,tx5)),tx6),tx7);
#(((((tx2,tx3),tx1),(tx4,tx5)),tx6),tx7);
#I used RAxML_bestTree.* files and concatenated them into one file.
#It works to compare trees made of four taxa, but will work with larger trees as well.
#taxaFile is a list of taxa by line with no other information. line 1, 2, and 3 are the ingroup taxa (e.g. tx1, tx2, tx3). Line 4 is the outgroup for rooting (e.g. tx7). 
#ex:
#tx1
#tx2
#tx3
#tx7
# Because of the way this is written, names must be identical across all gene trees and to the parameter file.  And an empty line mst be at the end of the parameter file.
#uninitialized value warnings can be disregarded (I suggest catching error 2>err).

use Bio::TreeIO;

my $treefile=shift;
my $parameterfile=shift;
my @taxa;

print "My triplet analysis taxa are:\n";
open(INFILE, $parameterfile) || die ("Can't open $parameterfile");
while(<INFILE>) {
	print "$_";
	chomp;
	push (@taxa, $_);
}
close (INFILE);

my $input = new Bio::TreeIO(-file   => "$treefile",
                            -format => "newick");
my $monophylyCounter=0;
my $otherMonophylyCounter=0;
my $finalMonophylyCounter=0;
my @trees;
while (my $tree = $input->next_tree) {
	push (@trees, $tree)
	}


for ($l=0; $l<=2; $l++) {
my $outgroup=$taxa[3];

 if ($l==0) {
	@ingroups=($taxa[0], $taxa[1]);
	$nonIngroup=$taxa[2]; }
elsif ($l==1) {

	@ingroups=($taxa[0], $taxa[2]);
	$nonIngroup=$taxa[1]; }
elsif ($l==2) {
	@ingroups=($taxa[1], $taxa[2]);
	$nonIngroup=$taxa[0]; } 
# reroot each tree at outgroup taxon.
foreach my $tree (@trees) {
	my $total_length = $tree->total_branch_length;

	#print "node count is ", scalar $tree->get_nodes, "\n";
	#print "the tree is this long: $total_length\n";
	my $rerootPos;
	my $i;
	my @nodes = $tree->get_nodes;
		for ($i=0; $i<=$#nodes; $i++) {
		#print "nodes id is", $nodes[$i]->id, "\n";
		if ($nodes[$i]->id eq $outgroup) {
		#print "match\n";		
		$rerootPos=$i;
		} else {
		next;
		}

		}
	#print "rerrot at $rerootPos\n";
	$tree->reroot($nodes[$rerootPos]);	
		#my $root = $tree->get_root_node;
		#print "root id:", $root->id, "\n";	
	my @ingroupPos;
	my $nonIngroupPos;
	@nodes = $tree->get_nodes;
		for ($i=0; $i<=$#nodes; $i++) {
		#print "nodes id is", $nodes[$i]->id, "\n";
		if (($nodes[$i]->id eq $ingroups[0]) || ($nodes[$i]->id eq $ingroups[1]) ) {
		#print "match at $i\n";		
		push (@ingroupPos, $i);
		} elsif ($nodes[$i]->id eq $nonIngroup) {
		$nonIngroupPos=$i;
		#print "matched nonIngroup, $nonIngroup\n";
		}	

	}
	#print join ("\t", @ingroupPos);
	#print "\n the nonIngroup is at $nonIngroupPos\n";
#test of monophyly for ingroup http://www.bioperl.org/wiki/HOWTO:Trees#Operations_on_Nodes
my @internalNodes=($nodes[$ingroupPos[0]], $nodes[$ingroupPos[1]]);
my $nonIngroupNode=$nodes[$nonIngroupPos];

if (( $tree->is_monophyletic (-nodes    => \@internalNodes,
                           -outgroup => $nonIngroupNode )) && $l==0 ){
#print "these nodes are monophyletic: ",
 #      join(",",map { $_->id } @internalNodes ), "\n";
	$monophylyCounter++;
}	
 
elsif (( $tree->is_monophyletic (-nodes    => \@internalNodes,
                           -outgroup => $nonIngroupNode )) && $l==1 ){
#print "these nodes are monophyletic: ",
 #      join(",",map { $_->id } @internalNodes ), "\n";
	$otherMonophylyCounter++;
}

elsif (( $tree->is_monophyletic (-nodes    => \@internalNodes,
                           -outgroup => $nonIngroupNode )) && $l==2 ){
#print "these nodes are monophyletic: ",
 #      join(",",map { $_->id } @internalNodes ), "\n";
	$finalMonophylyCounter++;
}




}


}

print "Total trees: ", $#trees+1,"\n";
print "$taxa[0] and $taxa[1] most closely related $monophylyCounter times.\n";
print "$taxa[0] and $taxa[2] most closely related $otherMonophylyCounter times.\n";
print "$taxa[1] and $taxa[2] most closely related $finalMonophylyCounter times.\n";
exit;
