#!/usr/bin/perl

use 5.010;
use warnings;
use strict;

my $msm="/usr/local/bin/msm";
my $server = "manaha";

my $operator = $ARGV[0];
my $MAX_TIME = 600; #10 minutes * 60 seconds
my $REMAINING_TIME = 10;
my $WARN_TIME = $MAX_TIME - $REMAINING_TIME; #Warn $REMAINING_TIME seconds before $MAX_TIME

my $config="/home/manaha-minecrafter/configs/operators.txt";

open(my $CONFIGFILE, $config) or die "Cannot open config file";
my @OPERATORS = <$CONFIGFILE>;

#Make operator
if(grep /$operator/, @OPERATORS){
	`$msm $server op add $operator`;
	`$msm $server say ***MAKING $operator AN OPERATOR***`;
}else{
	`$msm $server say Sorry, $operator, you do not have permission to become an operator!`;
	exit 1;
}

sleep $WARN_TIME;
`$msm $server cmd "/tell $operator 10 SECONDS LEFT OF OP POWERS!"`;
`$msm $server cmd "/tell $operator 10 WILL REMOVE CREATIVE MODE TOO!!"`;

sleep $REMAINING_TIME;
`$msm $server say ***REMOVING OPERATOR FUNCTIONS FROM $operator***`;
`$msm $server op remove $operator`;
`$msm $server cmd "/gamemode survival $operator"`;
