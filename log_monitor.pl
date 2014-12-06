#!/usr/bin/perl

use 5.010;
use POSIX qw(strftime);
use File::Slurp;

# CHECK WE ARE THE ONLY INSTANCE RUNNING
my $other_instance = `ps -ef | grep -vi grep | grep log_monitor.pl | grep perl | awk '{print \$2}'`;
chomp($other_instance);
my @instances = split(/^/m, $other_instance); # Match beginning of lines and add to array
foreach my $instance(@instances){
	if($instance != $$){
		system("kill $instance");
	}
}

# DEAMONISE OURSELF
my $pid = fork();
if($pid != 0){
	exit;
}

my $log = "/opt/msm/servers/manaha/logs/latest.log";
my $curpos;

my $msm="/usr/local/bin/msm";
my $server = "manaha";

my $perl="/usr/bin/perl";

my $scripts="/home/manaha-minecrafter/opt/";
my $PLAYER_LOG = "/home/manaha-minecrafter/public_html/players.html";

my $vault_lock = "/home/manaha-minecrafter/var/vault_lock";

open(my $LOGFILE, '-|', "tail -F -n -1 $log 2>/dev/null") or die "$!\n";

while(<$LOGFILE>){
	my $line = $_;
	chomp($line);

	s/.*<(.*)>.*/$1/; #Get player name
	my $PLAYER = $_; #Set player name
	chomp($PLAYER);
	
	# RUN OPERATOR SCRIPT
	if($line =~ /op me/i){
		#Fork process and run operator monitor script
		my $pid = fork();
		if(defined $pid && $pid == 0){
			system("$perl $scripts/op_monitor.pl $PLAYER");
			exit 0;
		}
	}

	# PLEASE STOP SWEARING
	if($line =~ /fuck/i || $line =~ /shit/i || $line =~ /f\*\*\*/i){
		`$msm $server say "No swearing please..."`;
	}
	
	# TELEPORT TO BANK
	if($line =~ /stuck in the vault!/i){
		sleep 1;
		`$msm $server say "Vault escaping was being misused. It is no longer available."`;
	#	my $vault_lock_file = "$vault_lock/$PLAYER";
	#	`touch $vault_lock_file`;
	#	sleep 1;
	#	say "1";
	#	my $player_number = read_file($vault_lock_file);
	#	chomp($player_number);
	#	say "2";
	#	if($player_number){
	#		if($player_number > 4){
	#			`$msm $server say "$PLAYER I did warn you"`;
        #                       `$msm $server cmd "tp $PLAYER 2584 200 -3"`;
	#		}elsif($player_number > 1){
	#			`$msm $server say "Sorry $PLAYER you cannot abuse it"`;
	#			$player_number++;
        #                       write_file($vault_lock_file, $player_number);
	#		}else{
	#			$player_number++;
	#			write_file($vault_lock_file, $player_number);
	#			my $tp_command = "tp $PLAYER 2622 2000 -1793";
	#			`$msm $server cmd $tp_command`;
	#		}
	#	}else{
	#		$player_number = 1;
	#		write_file($vault_lock_file, $player_number);
	#		my $tp_command = "tp $PLAYER 134 73 110";
	#		`$msm $server cmd $tp_command`;
	#	}
	}

	# Run logging on scripts
	if($line =~ /joined the game/){
		my $pid = fork();
		if(defined $pid && $pid == 0){
			$_ = $line;
			s/.*\: (.*) joined.*/$1/;
			$PLAYER = $_;
			system("$perl $scripts/log_in.pl $PLAYER");
			exit 0;
		}
	}

	# PLAYER ACCOUNTING
	if($line =~ /joined the game/){
		$_ = $line;
		s/.*\: (.*) joined.*/$1/;
		my $PLAYER = $_;
		
		say "Writing $PLAYER to site";

		my @players = read_file("/home/manaha-minecrafter/public_html/players.html");
		@players = grep(!/$PLAYER/, @players);
		my $new_entry = "<tr bgcolor='LimeGreen'><td>$PLAYER</td><td><b>ACTIVE NOW!</b></td></tr>\n";
		unshift(@players, $new_entry);

		write_file("/home/manaha-minecrafter/public_html/players.html", @players);
		
		
		system("echo \"`date '+%Y-%m-%d %H:%M:%S'` $PLAYER joined\" >> /home/manaha-minecrafter/opt/activity/activity.txt");
	}
	if($line =~ /left the game/){
		$_ = $line;
		s/.*\: (.*) left the ga.*/$1/;
		$PLAYER = $_;

		say $PLAYER;

		my @players = read_file("/home/manaha-minecrafter/public_html/players.html");
		say @players;
		print("\n\n\n");
		@players = grep(!/$PLAYER/, @players);
		say @players;
		my $time = strftime "%H:%M", localtime;
		my $date = strftime "%d %h %Y", localtime;
                my $new_entry = "<tr bgcolor='red'><td>$PLAYER</td><td>$time&nbsp;&nbsp;&nbsp;&nbsp;$date</td></tr>\n";
                unshift(@players, $new_entry);

                write_file("/home/manaha-minecrafter/public_html/players.html", @players);
		system("echo \"`date '+%Y-%m-%d %H:%M:%S'` $PLAYER left\" >> /home/manaha-minecrafter/opt/activity/activity.txt");
		system("/home/manaha-minecrafter/opt/activity/calculate_activity.pl");
        }
	# END PLAYER ACCOUNTING

			

	# HAVE WE DIED?
	if($line =~ /are you alive?/i){
		`echo "ALL OK" > /tmp/.allok`;
	}

	
}
