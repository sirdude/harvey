package advgame;

use IO::Prompter;

our @EXPORT = qw(
	set_debug
	query_debug
	usage
	get_prompt
);

my ($debug);

sub set_debug {
	my ($debug) = @_;
}

sub query_debug {
	if ($debug) {
		return 1;
	}
	return 0;
}

sub usage {
	print "Welcome to advperl help\n";
	print "basic usage:\n";
	print "\thelp\tThis help screen\n";
	print "\tgraph\tCreate a graph of the current states.\n";
	print "\tdebug\tToggle debug mode.\n";
	print "\tquit\tQuit the game.\n";
	print "\tsave FILENAME\tSave the game.\n";
	print "\tload FILENAME\tLoad a file.\n";
}

sub get_prompt {
	my ($question) = @_;

	my $ans = prompt $question;
	if ($ans eq "quit") {
		$ans = prompt "Quiting, Do you want to save? (y/n)";
		if ($ans eq "y") {
			print "Saving game.\n";
			# save_game();
		}
		exit 1;
	} elsif ($ans eq "load") {
	} elsif ($ans =~ /load (.*)/) {
	} elsif ($ans eq "save") {
	} elsif ($ans =~ /save (.*)/) {
	} elsif ($ans eq "help") {
		usage();
	} elsif ($ans eq "graph") {
	} elsif ($ans eq "debug") {
		if ($debug == 1) {
			print "Debugging turned off.\n";
			set_debug(0);
		} else {
			print "Debugging turned on.\n";
			set_debug(1);
		}
	}
	return $ans;
}

1;
