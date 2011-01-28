#!/usr/bin/perl -w

# J.T. Lomenick
# CSCI 481: Scripting Languages
# Assignment 4
# 11 November 2010

#=====================================================
# test number of command line arguments and store results
$numArgs = $#ARGV + 1;
if($numArgs > 2){
	print "ERROR: invalid number of command line arguments";
	exit;
}elsif($numArgs==2){
	$labelFile=$ARGV[0];
	$extraFile=$ARGV[1];
	%extraKeys=();
	open(EXTRAFILE, $extraFile) || die "Cant find file " . $extraFile;
	$line = <EXTRAFILE>;
	chomp($line);
	@otherLabels=();
	($geneID,@otherLabels) = split('\t',$line);
	@otherKeys=();
	while($line = <EXTRAFILE>){
		chomp($line);
		($geneKey,@otherKeys) = split('\t',$line);
		foreach (@otherKeys){
			push(@{$extraKeys{$geneKey}}, $_);
			
		}
	}
}else{
	$labelFile=$ARGV[0];
}

#========================================================
# Load hash array from label file
%labels = ();

open(LABELFILE, $labelFile)  || die "Cant find file " . $labelFile;
while($line = <LABELFILE>){
	chomp($line);
	($exprID, $result) = split ('\t', $line);
	$labels{$exprID} = $result;
}

#===========================================================
#read and store gene and values for each value in label hash
%genes = ();
foreach $exprID (sort (keys (%labels))){
	open(EXPRFILE, $exprID) || die "Cant find file " . $exprID;
	while($line = <EXPRFILE>){
		chomp($line);
		($geneID, $value) = split('\t',$line);
		push(@{$genes{$geneID}},$value);
		
	} 
}
#===============================================================
# print output in a table format
open(OUTPUT, ">lomenick.out");
print OUTPUT "ID\t";
if($numArgs==2){
	foreach (@otherLabels){
		print OUTPUT $_ . "\t";
	}
}
foreach $exprID (sort (keys (%labels))){
	$exprID =~ s/\..*//;
	print OUTPUT $exprID . "\t";
}
print OUTPUT "\n";
print OUTPUT "Label\t";
if($numArgs==2){
	foreach (@otherLabels){
		print OUTPUT "\t";
	}
}
foreach $exprID (sort (keys (%labels))){
	print OUTPUT $labels{$exprID} . "\t";
}
print OUTPUT "\n";
foreach $geneID (sort (keys (%genes))){
	print OUTPUT $geneID . "\t";
	if($numArgs==2){
		
		for $i(0.. $#{$extraKeys{$geneID}}){
			print OUTPUT $extraKeys{$geneID}[$i] . "\t";
		}
	}
	for $i (0.. $#{ $genes{$geneID}}){
		print OUTPUT  $genes{$geneID}[$i] . "\t";
	}
	print OUTPUT "\n";

    }
