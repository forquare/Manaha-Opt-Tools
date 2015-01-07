#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use POSIX qw(strftime);
use File::Slurp;

my $date = strftime "%d/%m", localtime;

my $lock_prefix = "xmas_";

my $player = $ARGV[0];

my %VARS = read_file( "/home/manaha-minecrafter/configs/common_variables.conf" ) =~ /^(.+)=(.*)$/mg ;

exit 0 if -e "$VARS{LOCK_DIR}/$lock_prefix$player";
# Sleep to allow the player to breath after the welcome messages

`$VARS{MSM} $VARS{SERVER} cmd "tell $player MERRY CHRISTMAS $player!"`;

# Give cake
`$VARS{MSM} $VARS{SERVER} cmd "give $player cake"`;
`$VARS{MSM} $VARS{SERVER} cmd "give $player golden_apple"`;
`$VARS{MSM} $VARS{SERVER} cmd "give $player gold_block"`;
`$VARS{MSM} $VARS{SERVER} cmd "give $player enchanted_book"`;
# Add 5 Levels
`$VARS{MSM} $VARS{SERVER} cmd "xp 5L $player"`;
# Let user resist 20% damage for 1 hour
`$VARS{MSM} $VARS{SERVER} cmd "effect $player 11 3600"`;
`touch $VARS{LOCK_DIR}/$lock_prefix$player`;
