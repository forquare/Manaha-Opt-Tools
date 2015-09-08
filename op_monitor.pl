#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use File::Slurp;

my %VARS = read_file( "/home/manaha-minecrafter/configs/common_variables.conf" ) =~ /^(.+)=(.*)$/mg ;

my $operator = $ARGV[0];
my $MAX_TIME = 600; #10 minutes * 60 seconds
my $REMAINING_TIME = 10;
my $WARN_TIME = $MAX_TIME - $REMAINING_TIME; #Warn $REMAINING_TIME seconds before $MAX_TIME

open(my $CONFIGFILE, $VARS{OPERATOR_CONFIG}) or die "Cannot open config file";
my @OPERATORS = <$CONFIGFILE>;

#Make operator
if(grep /$operator/, @OPERATORS){
	`$VARS{MSM} $VARS{SERVER} op add $operator`;
	`$VARS{MSM} $VARS{SERVER} say ***MAKING $operator AN OPERATOR***`;
}else{
	`$VARS{MSM} $VARS{SERVER} say Sorry, $operator, you do not have permission to become an operator!`;
	exit 1;
}

sleep $WARN_TIME;
`$VARS{MSM} $VARS{SERVER} cmd "/tell $operator 10 SECONDS LEFT OF OP POWERS!"`;
`$VARS{MSM} $VARS{SERVER} cmd "/tell $operator 10 WILL REMOVE CREATIVE MODE TOO!!"`;

sleep $REMAINING_TIME;
`$VARS{MSM} $VARS{SERVER} say ***REMOVING OPERATOR FUNCTIONS FROM $operator***`;
`$VARS{MSM} $VARS{SERVER} op remove $operator`;
`$VARS{MSM} $VARS{SERVER} cmd "/gamemode survival $operator"`;
