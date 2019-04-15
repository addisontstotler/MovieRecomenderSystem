#!usr/bin/perl
use warnings;

#Finds the user with the closest Minkouski distance based on movie ratings, then
#suggests a movie to watch

#Reads through ratings file
sub readRatings
{
    #Starts with the first user
    my $userNum = 1;
    my $inCommon = 0;
    $bestUser = 1;
    #A high distance to start out will for edge case
    my $tempDistance = 0;
    $leastDistance = 6;
    
    #Reads file line by line
    open DATAFILE, "ratings.csv";
    while(<DATAFILE>)
    {
	@line = split(/,/, $_);
	
	#If @line is a new user
	if($line[0] != $userNum)
	{
	    #Must have at least 15 movies in common (25% of what I rated)
	    if($inCommon >= 15 && $tempDistance < $leastDistance)
	    {
		$leastDistance = $tempDistance;
		$bestUser = $userNum;
	    }
	    $userNum = $line[0];
	    $tempDistance = 0;
	    $inCommon = 0;
	}

        #The same movies were rated
	if(exists $myRatings{"$line[1]"})
	{
	    $inCommon++;
	    $tempDistance = &minkowskiDistance($tempDistance, $myRatings{"$line[1]"}, $line[2], $inCommon);
	}
    }
}

#Calculates the minkowskiDistance
sub minkowskiDistance
{
    #Only to make the code more readable...
    my $distance = $_[0];
    my $x = $_[1];
    my $y = $_[2];
    my $r = $_[3];
    
    $distance = $distance**$r;

    my $newDistance = abs(($x-$y)**$r);
    ($distance + $newDistance)**(1/$r);
}

#Opens user's movie ratings
open DATAFILE, "myRatings.csv";

#Saves ratings to hash table
while(<DATAFILE>)
{
    my ($movieID, $rating) = split( /,/,$_);
    $myRatings{$movieID} = $rating;
}

&readRatings;

print "The best match is User: $bestUser\n";
print "You have a distance of: $leastDistance\n";
