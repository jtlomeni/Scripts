#!/usr/bin/perl -w

# J.T. Lomenick
# 9 December 2010
# CSCI 490: Scripting
# Final Project-Fantasy Football Stats Suite

#I have given nor recieved help in any part of this assignment.

#method for reading line and getting point total
sub getPoints
{
    $line = shift;
    $points =0;
    ($_, $_, $_,$yds,$td,$int,$_, 
$_,$rush_yds,$rush_td,$_,$rec,$rec_yds,$rec_td) = split('\t',$line);
    $points = ($yds/$ydsPerPPass) + ($td*$passTD) - ($int*$intP) + ($rush_yds/$ydsPerPRush) + ($rush_td*$rushTD) + ($rec/$recPerP) + ($rec_yds/$ydsPerPRec) + ($rec_td*$recTD);
    return $points;

}

#method for reading line and getting team name;
sub getTeam
{
    $line=shift;
    ($team,$_,$_,$_,$_) = split(' ' , $line);
    return $team;
    
}

#method for printing sorted hash
sub printHash
{
    my $teams = shift;
    foreach $team( sort {$teams{$a} <=> $teams{$b}} keys %teams){
        print "$team\t$teams{$team}\n";
    }


}

#method for reading file, storing values
sub collectData
{
    %teams = ();
    my $file = shift;
    open(IN, $file) || die "Cant find file";
    while($line = <IN>){
        chomp($line);
        $team = getTeam($line);
        $teams{$team} = getPoints($line);
    }
    return %teams;


}
#$scoreFile=$ARGV[0];
#======================================================================
print "\n\n\n";
print "===============================================\n";
print "===============================================\n";
print "Welcome to The Fantasy Football  Stats Suite\n";
print "===============================================\n";
print "===============================================\n\n\n";
print "Select an option to see the defensive ranks against a position:\n";
print "\t1.  Defense vs. Quarterbacks\n";
print "\t2.  Defense vs. Runningbacks\n";
print "\t3.  Defense vs. Wide Receivers\n";
print "\t4.  Defense vs. Tight Ends\n";
print "\t5.  Total Defense\n";
$selection =<>;


#====================================================================
#read in scoring settings

#method for getting each value for scoring settings
sub getValue
{
    $line = shift;
    chomp($line);
    @fields = split(' ',$line);
    return $fields[0];

}
sub getSettings{
	$scoreFile="scoringSettings.dat";
	open(IN,$scoreFile);
	$line=<IN>;
	$ydsPerPPass=getValue($line);
	$line=<IN>;
	$passTD=getValue($line);
	$line=<IN>;
	$intP=getValue($line);
	$line=<IN>;
	$ydsPerPRush=getValue($line);
	$line=<IN>;
	$rushTD= getValue($line);
	$line=<IN>;
	$recPerP=getValue($line);
	$line=<IN>;
	$ydsPerPRec=getValue($line);
	$line=<IN>;
	$recTD=getValue($line);
}
#=========================================================================
#Defense against QB
if($selection==1){
	 getSettings();
    %teams = collectData("qb.dat");
    print "\n\nDefense vs. Quarterbacks\n";
    print "Team\tPoints Given Up\n";
    print "===========================\n";
    printHash(%teams);
    print "\n";
}
#=========================================================================
#Defense against RB
elsif($selection==2){
    getSettings();
    %teams = collectData("rb.dat");
    print "\n\nDefense vs. Running Backs\n";
    print "Team\tPoints Given Up\n";
    print "=============================\n";
    printHash(%teams);

}
#=========================================================================
#Defensive against WR
elsif($selection==3){
    getSettings();
    %teams = collectData("wr.dat");
    print "\n\nDefense vs. Wide Receivers\n";
    print "Team\tPoints Given Up\n";
    print "=============================\n";
    printHash(%teams);
}
#=========================================================================
#Defense against TE
elsif($selection==4){
    getSettings();
    %teams = collectData("te.dat");
    print "\n\nDefense vs. Tight Ends\n";
    print "Team\tPoints given up\n";
    print "=============================\n";
    printHash($teams);
}
#==========================================================================
#Total Defense
elsif($selection==5){
    getSettings();
    %teams = ();
    open(IN,"qb.dat") || die "Cant Find QB File";
    while($line=<IN>){
        chomp($line);
	$team = getTeam($line);
	$teams{$team}=getPoints($line);
    }
    open(IN,"rb.dat") || die "Cant Find RB File";
    while($line=<IN>){
        chomp($line);
	$team = getTeam($line);
	$teams{$team}+=getPoints($line);
    }
    open(IN,"wr.dat") || die "Cant Find wr File";
    while($line=<IN>){
        chomp($line);
        $team = getTeam($line);
	$teams{$team}+=getPoints($line);
    }
    open(IN,"te.dat") || die "Cant Find Te File";
    while($line=<IN>){
        chomp($line);
        $team = getTeam($line);
	$teams{$team}+=getPoints($line);
    }
    print "\n\nTOTAL DEFENSE\n";
    print "Team\tPoints given up\n";
    print "======================\n";
    printHash($teams);

}else{

    print "Please enter a valid input\n";
}
