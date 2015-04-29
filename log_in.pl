#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use File::Slurp;

my %VARS = read_file( "/home/manaha-minecrafter/configs/common_variables.conf" ) =~ /^(.+)=(.*)$/mg ;

my $giving_dir=$VARS{OPT_DIR} . "/give_on_log_in";

my $perl="/usr/bin/perl";

my $player = $ARGV[0];

# Sleep for 5 seconds before starting - allows client to load properly
sleep 5;

`$VARS{MSM} $VARS{SERVER} cmd "tell $player Welcome $player!"`;
`$VARS{MSM} $VARS{SERVER} cmd "tell $player $VARS{WELCOME_MESSAGE}"`;

system("$perl $giving_dir/birthdays.pl $player");
#system("$perl $giving_dir/christmas.pl $player");
system("$perl $giving_dir/random_gift.pl $player");
system('cat /opt/msm/servers/manaha/whitelist.json | grep name| sed \'s/.*name\": \"\(.*\)\"/\1/g\' > /home/manaha-minecrafter/opt/players.txt');

my %UNDERAGE = read_file( "/home/manaha-minecrafter/configs/under16.txt" ) =~ /^(.+)=(.*)$/mg ;

if(exists $UNDERAGE{$player}){
	`$VARS{MSM} $VARS{SERVER} cmd "tell $player URGENT: PLEASE READ mc.manaha.co.uk/under16.html"`;
	`$VARS{MSM} $VARS{SERVER} cmd "tell $player CONTINUE PLAYING **ONLY** IF YOU HAVE READ AND ACCEPT"`;
}
