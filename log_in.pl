#!/usr/bin/perl

use 5.010;
use warnings;
use strict;
use File::Slurp;

my $msm="/usr/local/bin/msm";
my $server = "manaha";

my $scripts="/home/manaha-minecrafter/opt/";
my $giving_dir="$scripts/give_on_log_in";

my $perl="/usr/bin/perl";

my $player = $ARGV[0];

# Sleep for 5 seconds before starting - allows client to load properly
sleep 5;

`$msm $server cmd "tell $player Welcome $player!"`;
`$msm $server cmd "tell $player Keep up to date with current news, join the forums"`;
#`$msm $server cmd "tell $player Please sign up to the forum if you have not already"`;
#`$msm $server cmd "tell $player http://mc.manaha.co.uk/forum"`;

system("$perl $giving_dir/birthdays.pl $player");
system("$perl $giving_dir/random_gift.pl $player");
system('cat /opt/msm/servers/manaha/whitelist.json | grep name| sed \'s/.*name\": \"\(.*\)\"/\1/g\' > /home/manaha-minecrafter/opt/players.txt');

my %UNDERAGE = read_file( "/home/manaha-minecrafter/configs/under16.txt" ) =~ /^(.+)=(.*)$/mg ;

if(exists $UNDERAGE{$player}){
	`$msm $server cmd "tell $player URGENT: PLEASE READ mc.manaha.co.uk/under16.html"`;
	`$msm $server cmd "tell $player CONTINUE PLAYING **ONLY** IF YOU HAVE READ AND ACCEPT"`;
#	`echo "" >> /var/tmp/told_you_so`;
#	`date >> /var/tmp/told_you_so`;
#	`echo "Would have told $player" >> /var/tmp/told_you_so`;
#	`echo "" >> /var/tmp/told_you_so`;
}
