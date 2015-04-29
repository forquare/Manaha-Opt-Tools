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

my %VARS = read_file( "/home/manaha-minecrafter/configs/common_variables.conf" ) =~ /^(.+)=(.*)$/mg ;

my $curpos;

open(my $LOGFILE, '-|', "tail -F -n -1 $VARS{SERVER_LOGS} 2>/dev/null") or die "$!\n";

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
			system("$VARS{PERL} $VARS{OPT_DIR}/op_monitor.pl $PLAYER");
			exit 0;
		}
	}

	# PLEASE STOP SWEARING
	if($line =~ /fuck/i || $line =~ /shit/i || $line =~ /f\*\*\*/i){
		`$VARS{MSM} $VARS{OPERATOR_CONFIG} say "No swearing please..."`;
	}
	
	# TELEPORT TO BANK
	if($line =~ /stuck in the vault!/i){
		sleep 1;
		`$VARS{MSM} $VARS{OPERATOR_CONFIG} say "Vault escaping was being misused. It is no longer available."`;
	#	my $vault_lock_file = "$vault_lock/$PLAYER";
	#	`touch $vault_lock_file`;
	#	sleep 1;
	#	say "1";
	#	my $player_number = read_file($vault_lock_file);
	#	chomp($player_number);
	#	say "2";
	#	if($player_number){
	#		if($player_number > 4){
	#			`$VARS{MSM} $VARS{OPERATOR_CONFIG} say "$PLAYER I did warn you"`;
        #                       `$VARS{MSM} $VARS{OPERATOR_CONFIG} cmd "tp $PLAYER 2584 200 -3"`;
	#		}elsif($player_number > 1){
	#			`$VARS{MSM} $VARS{OPERATOR_CONFIG} say "Sorry $PLAYER you cannot abuse it"`;
	#			$player_number++;
        #                       write_file($vault_lock_file, $player_number);
	#		}else{
	#			$player_number++;
	#			write_file($vault_lock_file, $player_number);
	#			my $tp_command = "tp $PLAYER 2622 2000 -1793";
	#			`$VARS{MSM} $VARS{OPERATOR_CONFIG} cmd $tp_command`;
	#		}
	#	}else{
	#		$player_number = 1;
	#		write_file($vault_lock_file, $player_number);
	#		my $tp_command = "tp $PLAYER 134 73 110";
	#		`$VARS{MSM} $VARS{OPERATOR_CONFIG} cmd $tp_command`;
	#	}
	}

	# Run logging on scripts
	if($line =~ /joined the game/){
		my $pid = fork();
		if(defined $pid && $pid == 0){
			$_ = $line;
			s/.*\: (.*) joined.*/$1/;
			$PLAYER = $_;
			system("$VARS{PERL} $VARS{OPT_DIR}/log_in.pl $PLAYER");
			exit 0;
		}
	}

	# PLAYER ACCOUNTING
	if($line =~ /joined the game/){
		$_ = $line;
		s/.*\: (.*) joined.*/$1/;
		my $PLAYER = $_;
		
		say "Writing $PLAYER to site";

		my @players = read_file($VARS{PLAYERS_HTML});
		@players = grep(!/$PLAYER/, @players);
		my $new_entry = "<tr bgcolor='LimeGreen'><td>$PLAYER</td><td><b>ACTIVE NOW!</b></td></tr>\n";
		unshift(@players, $new_entry);

		write_file($VARS{PLAYERS_HTML}, @players);
		
		
		system("echo \"`date '+%Y-%m-%d %H:%M:%S'` $PLAYER joined\" >> $VARS{ACTIVITY_LOG}");
	}
	if($line =~ /left the game/){
		$_ = $line;
		s/.*\: (.*) left the ga.*/$1/;
		$PLAYER = $_;

		say $PLAYER;

		my @players = read_file($VARS{PLAYERS_HTML});
		say @players;
		print("\n\n\n");
		@players = grep(!/$PLAYER/, @players);
		say @players;
		my $time = strftime "%H:%M", localtime;
		my $date = strftime "%d %h %Y", localtime;
                my $new_entry = "<tr bgcolor='red'><td>$PLAYER</td><td>$time&nbsp;&nbsp;&nbsp;&nbsp;$date</td></tr>\n";
                unshift(@players, $new_entry);

                write_file($VARS{PLAYERS_HTML}, @players);
		system("echo \"`date '+%Y-%m-%d %H:%M:%S'` $PLAYER left\" >> $VARS{ACTIVITY_LOG}");
		system("/home/manaha-minecrafter/opt/activity/calculate_activity.pl");
        }
	# END PLAYER ACCOUNTING

			

	# HAVE WE DIED?
	if($line =~ /are you alive?/i){
		`echo "ALL OK" > /tmp/.allok`;
	}

	
}
