#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use DateTime;
use File::Slurp;
use POSIX qw/ceil/;

my %VARS = read_file( "/home/manaha-minecrafter/configs/common_variables.conf" ) =~ /^(.+)=(.*)$/mg ;

my @PLAYER_FILE = read_file($VARS{PLAYERS});
chomp(@PLAYER_FILE);
my %PLAYERS = map { $_ => 0 } @PLAYER_FILE;

my @LOG = read_file($VARS{ACTIVITY_LOG});

foreach my $player (keys %PLAYERS){
	my @activity = grep(/$player/, @LOG);
	chomp(@activity);
	
	for(my $i = 0; $i < @activity; $i++){
		if($activity[$i] =~ /left/){
			next;
		}

		my @joined = split(/ /,$activity[$i]);
		my ($jhour, $jminute, $jsecond) = split(/:/, $joined[1]);
		my ($jyear, $jmonth, $jday) = split(/-/, $joined[0]);
		my $dt = DateTime->new(
					year	=>	$jyear,
					month	=>	$jmonth,
				      	day	=>	$jday,
					hour	=>	$jhour,
					minute	=>	$jminute,
					second	=>	$jsecond);
		my $joined_timestamp = $dt->epoch();

		my @left = undef;
		if($i < @activity - 1){
			if($activity[$i+1] =~ /left/){
				@left = split(/ /,$activity[$i+1]);
				$i++;
			}else{
				next;
			}
		}else{
			last;
		}
		my ($lhour, $lminute, $lsecond) = split(/:/, $left[1]);
		my ($lyear, $lmonth, $lday) = split(/-/, $left[0]);
		$dt = DateTime->new(
                                        year    =>      $lyear,
                                        month   =>      $lmonth,
                                        day     =>      $lday,
                                        hour    =>      $lhour,
                                        minute  =>      $lminute,
                                        second  =>      $lsecond);
		my $left_timestamp = $dt->epoch();

		my $logged_time = ($left_timestamp - $joined_timestamp)/3600;
		$PLAYERS{$player} = $PLAYERS{$player} + $logged_time;
	}
	$PLAYERS{$player} = ceil($PLAYERS{$player});
}
my $output = "";

sub hashValueDescendingNum {
   $PLAYERS{$b} <=> $PLAYERS{$a};
}

foreach my $player (sort hashValueDescendingNum (keys(%PLAYERS))){
	$output = "$output $player=$PLAYERS{$player}\n";
}
write_file($VARS{ACTIVITY_OUTPUT}, $output);
