#!/usr/bin/perl
use strict;
use Getopt::Std;

# - - - - - H E A D E R - - - - - - - - - - - - - - - - -
#Goals of script:
#Get abundance from cd-hit's *.clstr file to map back to the representative sequences chosen.
#Reminder: CD-hit tends to keep the ">" in the header in the clstr file. You need to remove these internal ">"'s.
#You also need to delete the trailing line feed at the end of the file.

# - - - - - U S E R    V A R I A B L E S - - - - - - - -


# - - - - - G L O B A L  V A R I A B L E S  - - - - - -
my %options=();
#my @DATA3;
getopts("c:l:a:h", \%options);
#my %Sequences;
my %Abundance;

if ($options{h})
    {   print "\n\nHelp called:\nOptions:\n";
	#print "-c = cd hit fasta file\n";
        print "-l = cd hit clstr file\n";
        print "-h = This help message\n\n";
	print "-a = 100% Abundance file for cdhit recov from SILVA";
	die;
    }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - M A I N - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#&FASTAread($options{c}, 1);

##### 1. Deal with file s (stats)
#if (defined $options{a})
#    {
print "\n\nOpening infile: $options{a}";
open(IN, "<$options{a}") or die "\n\nNADA $options{a} you FOOL!!!\n\n";
my @DATA3 = <IN>; close(IN);
    #}


print "\n\nOpening infile: $options{l}";


$/=">";                                     # set input break string
open(IN, "<$options{l}") or die "\n\nNADA $options{l} you FOOL!!!\n\n";
my @DATA2 = <IN>; close(IN); shift(@DATA2);
my $unid2 = 100001;
$/="\n";
foreach my $i (@DATA2)
    {	my @data = split('\n', $i);
	if ($data[$#data] eq ">"){pop(@data);} shift(@data);
	$Abundance{$unid2}{'abundance'} = $#data+1;
	foreach my $j (@data)
	    {	if ($j =~ m/\*$/)
		    {	my @n = split(' ', $j);
			my $name = $n[2];
			$name =~ s/\.\.\.//;
			$Abundance{$unid2}{'name'} = $name;
		    }
	    }
	#if(defined $options{a}){
	    foreach my $j (@data)
		{	my @n = split(' ', $j);
			my $name = $n[2];
			$name =~ s/\.\.\.//;
		    foreach my $k (@DATA3)
			{	chomp($k);
				my @splitt = split("\t", $k);
				my $fed = $splitt[0];
				if ($name eq $fed)
				{
					$Abundance{$unid2}{'abundance'} += $splitt[1];
					$Abundance{$unid2}{'abundance'} -= 1;
				}
			}
		}
	    #}
	$unid2 += 1;
    }



print "\n\n*****DONE*****\n\n";




open(OUT1, ">$options{l}"."_abundance.txt");
foreach my $j (sort keys %Abundance)
    {	print OUT1 "$Abundance{$j}{'name'}\t$Abundance{$j}{'abundance'}\n";
    }
close(OUT1);

print "\n\n* * * * * * * * D O N E * * * * * * * *\n\n";

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - S U B R O U T I N E S - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#sub FASTAread
#{	print "   Reading file . . . \n";
#	# 1. Load FIlE . . . . . . . . . .
#	$/=">";                                     # set input break string
#	my $infile = $_[0];
#        my $filenumber = $_[1];
#	open(IN, "<$infile") or die "\n\nNADA $infile 2 you FOOL!!!\n\n";
#	my @DATA = <IN>; close(IN); shift(@DATA);	
#	# 2. Parse sequence data . . . . . . . . . . . . .
#	my $unid = $filenumber.10001;                           # string to generate unique ids
#	foreach my $entry (@DATA)
#	{	my @data = split('\n', $entry);
#		my $seq = '';
#		foreach my $i (1..$#data)
#		{	$seq .= $data[$i];  }
#		$seq =~ s/>//;
#		$Sequences{$unid}{'HEAD'}    = $data[0];       # store header
#		$Sequences{$unid}{'gappy-ntseq'}   = uc($seq);       # store aligned sequence
#		$Sequences{$unid}{'SIZE'}    = length($seq);   # store length
#		$seq =~ s/\.//;
#                $seq =~ s/\-//;
#                $Sequences{$unid}{'degapped-ntseq'} = uc($seq);     # store degapped sequence
#                $Sequences{$unid}{'filenumber'} = $filenumber;
#                $unid += 1;
#	}
#	$/="\n";
#}
# - - - - - EOF - - - - - - - - - - - - - - - - - - - - - -
