#!usr/bin/perl
use warnings;

#Hash table of recomendedUser
open DATAFILE, "recomendedUser.csv";
while(<DATAFILE>)
{
    my @line = split(/,/,$_);
    $recomendedRatings{$line[1]} = $line[2];
}
close DATAFILE;

#Populates a Hash with movies
open DATAFILE, "movies.csv";
while(<DATAFILE>)
{
    my @line = split(/,/,$_);
    $movies{$line[0]} = $line[1];
}

#Loops through the recomendedRatings
while (($recKey, $recValue) = each %recomendedRatings)
{
    #Only the movies I have not seen and the highly rated ones
    if($recValue >= 4)
    {
	print "Have you seen movie: $movies{$recKey}?\n";
	my $answer = <STDIN>;
	chomp($answer);

	if($answer eq "n")
	{
	    print "\n";
	    print "Watch $movies{$recKey}!\n";
	    print "Movie ID: $recKey.\n";
	    last;
	}
    }
}
