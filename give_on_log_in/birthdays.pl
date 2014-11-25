#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use POSIX qw(strftime);
use File::Slurp;

my $date = strftime "%m/%d", localtime;

my $msm="/usr/local/bin/msm";
my $server = "manaha";

my $lock = "/home/manaha-minecrafter/var/birthday_lock";
my $lock_prefix = "birthday_";

my $player = $ARGV[0];

my %PLAYERS = read_file( "/home/manaha-minecrafter/configs/birthdays.txt" ) =~ /^(.+)=(.*)$/mg ;

if($date eq $PLAYERS{$player}){
	exit 0 if -e "$lock/$lock_prefix$player";
	# Sleep to allow the player to breath after the welcome messages
	# Sleep here so if it *isn't* a birthday we don't hold up the player
	sleep 5;

	
	`$msm $server cmd "tell $player Happy Birthday $player!"`;
	# Give cake
	`$msm $server cmd "give $player cake"`;
	# Add 5 Levels
	`$msm $server cmd "xp 5L $player"`;
	# Let user resist 20% damage for 1 hour
	`$msm $server cmd "effect $player 11 3600"`;
	`touch $lock/$lock_prefix$player`;
}
