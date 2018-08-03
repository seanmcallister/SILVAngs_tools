#!/usr/bin/perl
use strict;
use Getopt::Std;

# - - - - - H E A D E R - - - - - - - - - - - - - - - - -
#Goals of script:
#Convert the SILVA next generation sequencing classification pipeline export (.csv)
#to a format equivalent to the qiime pipeline (so it can be brought in as the taxa summary).
#Sean McAllister 07/03/16. version 2.0.
#Updated 03/19/17. version 3.0.


# - - - - - U S E R    V A R I A B L E S - - - - - - - -


# - - - - - G L O B A L  V A R I A B L E S  - - - - - -
my %options=();
getopts("f:h", \%options);


if ($options{h})
    {   print "\n\nHelp called:\nOptions:\n";
	print "-f = SILVA csv file, i.e. x---ssu---otus.csv, which is actually a tab delimited file\n";
        print "-h = This help message\n\n";
	die;
    }


my %Samples;

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - M A I N - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#  2. Load and parse infile into dictionary.
open(IN,"<$options{f}") or die "\n\nError, there is no file named $options{f}.\n\n";
my @FILE = <IN>; chomp(@FILE);
close(IN);
my $header = shift(@FILE);
$header =~ s/\n//;
$header =~ s/\r//;
my @headerarray = split("\t",$header);
my $ID = 10001;
#my $count = 1;
foreach my $OTUline (@FILE)
{   $OTUline =~ s/\n//;
    $OTUline =~ s/\r//;
    my @data = split("\t", $OTUline);
    $Samples{$ID}{'sample_name'} = $data[0];
    $Samples{$ID}{'cluster_id'} = $data[1];
    $Samples{$ID}{'cluster_acc'} = $data[2];
    $Samples{$ID}{'number_sequences'} = $data[3];
    $Samples{$ID}{'avg_seq_identity'} = $data[4];
    $Samples{$ID}{'similarity'} = $data[5];
    $Samples{$ID}{'sequence'} = $data[6];
    $Samples{$ID}{'ncbi_classification'} = $data[7];
    $Samples{$ID}{'silva_classification'} = $data[8];
    $ID += 1;
}

#4. Generate outfiles for import into Qiime pipeline.
print "\n\nGenerating output file . . .";

open(OUT, ">$options{f}_qiimeconv.txt");
foreach my $id (sort keys %Samples)
{   my $percsim = ($Samples{$id}{'similarity'}/100);
    my $simpleclass = $Samples{$id}{'silva_classification'};
    $simpleclass =~ s/silva\|\d+\|\d+\|//;
    print OUT "$Samples{$id}{'cluster_acc'}\t$simpleclass\t$percsim\n";
}
close(OUT);



print "\n\n* * * * * * D O N E * * * * * *\n\n";

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - S U B R O U T I N E S - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# - - - - - EOF - - - - - - - - - - - - - - - - - - - - - -
