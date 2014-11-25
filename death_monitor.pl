#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use File::Slurp;

my $msm="/usr/local/bin/msm";
my $server = "manaha";

my $scripts="/home/manaha-minecrafter/opt/";

my $perl="/usr/bin/perl";

my $player = $ARGV[0];
my $line = $ARGV[1];

my @DEATHS =  read_file("/home/manaha-minecrafter/docs/deaths.txt");

foreach $death (@DEATHS){
	# if $death appears in $line
	# Output line to log file
}
