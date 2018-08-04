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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - M A I N - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

##### 1. Deal with file
#print "\n\nOpening infile: $options{c}";
open(IN, "<$options{c}") or die "\n\nFile $options{c} doesn't exist; try again\n\n";
my @DATA2 = <IN>; close(IN);
my $clusterhead = "";
foreach my $i (@DATA2)
    {	chomp($i);
	if ($i =~ m/^>/)
	 {	$clusterhead = $i;
	 }
	else
	 {	$i =~ m/.+, >(.+)\.\.\./;
		my $header = $1;
		$Cluster{$clusterhead}{'sequences'} .= $header.';';
		if ($i =~ m/\*$/)
		 {	$Cluster{$clusterhead}{'rep_seq'} = $header;
		 }
		#print "$clusterhead\t$Cluster{$clusterhead}{'sequences'}\t<<$Cluster{$clusterhead}{'rep_seq'}>>\n";
	 }
    }

#Match headers of interest and print all seqs from cluster to STDOUT.
open(IN2, "<$options{i}") or die "\n\nPlease don't forget to provide a list of headers of interest. File $options{i} doesn't exist.\n\n";
my @DATA = <IN2>; close(IN2);
foreach my $i (@DATA)
	{	chomp($i);
		foreach my $j (sort keys %Cluster)
			{	if ($i eq $Cluster{$j}{'rep_seq'})
					{	my $seqs = $Cluster{$j}{'sequences'};
						my @split_seqs = split(';', $seqs);
						foreach my $k (@split_seqs)
							{	print "$k\n";
							}
					}
			}
	}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - S U B R O U T I N E S - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# - - - - - EOF - - - - - - - - - - - - - - - - - - - - - -
