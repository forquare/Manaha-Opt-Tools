#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use POSIX qw(strftime);
use File::Slurp;

my $date = strftime "%m/%d", localtime;

my %VARS = read_file( "/home/manaha-minecrafter/configs/common_variables.conf" ) =~ /^(.+)=(.*)$/mg ;

my $random_item = int(rand(432));

my $player = $ARGV[0];

sleep 5;

my %ITEMS = (
        47      =>      "a Bookcase",
        263     =>      "some Coal",
        264     =>      "some Diamond",
        265     =>      "some Iron",
        266     =>      "some Gold",
        276     =>      "a Diamond Sword",
        297     =>      "some Bread",
        344     =>      "an Egg",
        329     =>      "a Sadle",
        331     =>      "some Redstone",
        340     =>      "a Book",
        341     =>      "some Slime",
        420     =>      "a Lead",
        421     =>      "a Tag",
);

my %DECODE = (
        47      =>      "bookshelf",
        263     =>      "coal",
        264     =>      "diamond",
        265     =>      "iron_ingot",
        266     =>      "gold_ingot",
        276     =>      "diamond_sword",
        297     =>      "bread",
        344     =>      "egg",
        329     =>      "sadle",
        331     =>      "redstone",
        340     =>      "book",
        341     =>      "slime",
        420     =>      "lead",
        421     =>      "name_tag",
);

if(exists $ITEMS{$random_item}){
	`$VARS{MSM} $VARS{SERVER} cmd "tell $player Congratulations!  You have just won"`;
	`$VARS{MSM} $VARS{SERVER} cmd "tell $player $ITEMS{$random_item}"`;
	`$VARS{MSM} $VARS{SERVER} cmd "give $player $DECODE{$random_item}"`;
}else{
	unless($random_item % 12){
		`$VARS{MSM} $VARS{SERVER} cmd "tell $player You won the booby prize!"`;
		`$VARS{MSM} $VARS{SERVER} cmd "tell $player have some rotten flesh!"`;
		`$VARS{MSM} $VARS{SERVER} cmd "give $player rotten_flesh"`;
	}	
}
