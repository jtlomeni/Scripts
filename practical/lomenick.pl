#!/usr/bin/perl -w

#============================================
%employees =();
open(INFILE, "timesheet.dat") || die "Cat find file";
while($line = <INFILE>){
	chomp($line);
	($id,$month,$day,$hours) = split ('\t', $line);
	$employees{$id}{$month} += $hours;
}
#===============================

$yearTotal = 0;
foreach my $id (sort (keys (%employees))){
	print "Employee ID: " . $id . "\n";
	$total = 0;
	for $month (sort (keys %{$employees{$id}})){
		$total+=$employees{$id}{$month};
		print "    " . $month . "\t" .  $employees{$id}{$month} . "\n";
	}
	print  "   Total: " . $total . "\n\n";
 	$yearTotal+=$total;
}

print "Total hours this year: $yearTotal \n\n";
