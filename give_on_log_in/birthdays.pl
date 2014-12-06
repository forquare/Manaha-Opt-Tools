#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use POSIX qw(strftime);
use File::Slurp;

my $date = strftime "%m/%d", localtime;

my $lock_prefix = "birthday_";

my $player = $ARGV[0];

my %PLAYERS = read_file( "/home/manaha-minecrafter/configs/birthdays.txt" ) =~ /^(.+)=(.*)$/mg ;
my %VARS = read_file( "/home/manaha-minecrafter/configs/common_variables.conf" ) =~ /^(.+)=(.*)$/mg ;

if($date eq $PLAYERS{$player}){
	exit 0 if -e "$VARS{LOCK_DIR}/$lock_prefix$player";
	# Sleep to allow the player to breath after the welcome messages
	# Sleep here so if it *isn't* a birthday we don't hold up the player
	sleep 5;

	
	`$VARS{MSM} $VARS{SERVER} cmd "tell $player Happy Birthday $player!"`;
	# Give cake
	`$VARS{MSM} $VARS{SERVER} cmd "give $player cake"`;
	# Add 5 Levels
	`$VARS{MSM} $VARS{SERVER} cmd "xp 5L $player"`;
	# Let user resist 20% damage for 1 hour
	`$VARS{MSM} $VARS{SERVER} cmd "effect $player 11 3600"`;
	`touch $VARS{LOCK_DIR}/$lock_prefix$player`;
}
