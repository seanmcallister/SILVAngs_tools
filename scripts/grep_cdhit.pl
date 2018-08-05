#!/usr/bin/perl
use strict;
use Getopt::Std;

# - - - - - H E A D E R - - - - - - - - - - - - - - - - -
#Goals of script:
#Grep a list of headers from the cdhit *.clstr file, retrieving all the sequences that are in each cluster.

# - - - - - U S E R    V A R I A B L E S - - - - - - - -


# - - - - - G L O B A L  V A R I A B L E S  - - - - - -
my %options=();
getopts("c:i:h", \%options);

if ($options{h})
    {   print "\n\nHelp called:\nOptions:\n";
        print "-i = List of headers, one per line\n";
	print "-c = cd hit clstr file\n";
        print "-h = This help message\n\n";
	die;
    }

my %Cluster;
my %KeyRep;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - M A I N - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

##### 1. Deal with file
#print "\n\nOpening infile: $options{c}";
open(IN2, "<$options{i}") or die "\n\nPlease don't forget to provide a list of headers of interest. File $options{i} doesn't exist.\n\n";
my @DATA = <IN2>; close(IN2);

open(IN, "<$options{c}") or die "\n\nFile $options{c} doesn't exist; try again\n\n";
my @DATA2 = <IN>; close(IN);
my $unid = 10001;
foreach my $i (@DATA2)
    {	chomp($i);
	if ($i =~ m/^>/)
	 {	$unid += 1;
		unless ($unid - 1 == 10001)
			{	my $interest = $unid - 1;
				$KeyRep{$Cluster{$interest}{'rep_seq'}}{'sequences'} = $Cluster{$interest}{'sequences'};
			}
	 }
	else
	 {	$i =~ m/.+, >(.+)\.\.\./;
		my $header = $1;
		$Cluster{$unid}{'sequences'} .= $header.';';
		if ($i =~ m/\*$/)
		 {	$Cluster{$unid}{'rep_seq'} = $header;
		 }
		#print "$clusterhead\t$Cluster{$clusterhead}{'sequences'}\t<<$Cluster{$clusterhead}{'rep_seq'}>>\n";
	 }
    }
    
#Add the last entry to %KeyRep
$KeyRep{$Cluster{$unid}{'rep_seq'}}{'sequences'} = $Cluster{$unid}{'sequences'};

foreach my $i (@DATA)
	{	chomp($i);
		my $seqs = $KeyRep{$i}{'sequences'};
		my @split_seqs = split(';', $seqs);
		foreach my $k (@split_seqs)
			{	print "$k\n";
			}
	}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - S U B R O U T I N E S - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# - - - - - EOF - - - - - - - - - - - - - - - - - - - - - -
