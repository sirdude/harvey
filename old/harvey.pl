#!/usr/bin/perl

use strict;
use warnings;
use IO::Prompter;
use Getopt::Long;

my (%options, %choices, %states, $state, $infile, $debug);

sub usage {
	print "Usage: $0 [datafile]\n";
	print "Welcome to our game engine for harvey.  It has a long way " .
		"to go at this point.  Feel free to play around with it and " .
		"give us feedback.";
	print "Options:\n";
	print "\t--help\tDisplay this help message.\n";
	print "\t--debug\tTurn on debugging mode.\n";
	print "\t--loadstate=FILE\tLoad the statefile FILE\n";
	print "\t--startstate=STATE\tStart at STATE.\n";
	return 1;
}

# Read in our game data file.
sub read_data {
	my ($filename) = @_;
	my $count = 0;

	if (!-f $filename) {
		print "Unable to open $filename\n";
		return 0;
	}

	open(my $fh, "<", $filename) or die "Unable to open $filename\n";
	while(<$fh>) {
		my $line = $_;

		$count = $count + 1;
		if ($line =~ /#(.*)/) {
			# Skip comments
		} elsif ($line =~ /(.*):(.*):(.*):(.*):(.*):(.*)/) {
# XXX
		} else {
			print "Error in $filename: $count\n";
			return 0;
		}
		
	}
	return 1;
}

# Read in our saved state file.
sub load_state {
	my ($filename) = @_;
	my $count = 0;
	my $line;

	if (!-f $filename) {
		print "Unable to open $filename\n";
		return 0;
	}

	open(my $fh, "<", $filename) or die "Unable to open $filename\n";
	while(<$fh>) {
		$count = $count + 1;
		$line = $_;

		if ($line =~ /choices:(.*):(.*)/) {
			$choices{$1} = $2;
		} elsif ($line =~ /states:(.*):(.*)/) {
			$states{$1} = $2;
		} elsif ($line =~ /state:(.*)/) {
			$state = $1;
		} else {
			close ($fh);
			print "Error in line $count\n";

			return 0;
		}
	}
	close($fh);
	return 1;
}

# Write out our current save file.
sub dump_state {
	my ($filename) = @_;

	open(my $fh, ">", $filename) or die "Unable to open $filename\n";
	foreach my $i (%choices) {
		print $fh "choices:$i:$choices{$i}\n";
	}
	foreach my $i (%states) {
		print $fh "states:$i:$states{$i}\n";
	}
	print $fh "state:$state\n";
	return 1;
}

# This function starts at start and goes to state along
# The traveled path.  Then it marks other paths as previously explored.
# If we go a->b->c->d->e  and then jump back to b we have to
# mark b-c->d->-e as prevously explored but not current.  We also have to
# undo effects.
sub update_path {
}

# Write out the current graph of our state.
sub print_graph {
	my ($graphfile) = @_;

	open(my $fh, ">", $graphfile) or die "Unable to open $graphfile\n";
	print $fh "# Use neato -Tpng $graphfile -o $graphfile.png\n";
	print $fh "digraph Graph {\n";
	print $fh "\toverlap = scale\n";

	# XXX do states here

	print $fh "}\n";
	close $fh;
	return 1;
}

sub eval_state {
	my ($place) = @_;

# XXX Need to update state and re eval new state
	return 1;
}


GetOptions(\%options, "help", "debug", "loadstate=s", "startstate=s");

if ($options{"help"}) {
	usage();
	exit 1;
}
if ($options{"debug"}) {
	$debug = 1;
} else {
	$debug = 0;
}

($infile) = @ARGV;
if (!$infile || $infile eq "") {
	$infile = "harvey.data";
}

if (!read_data($infile)) {
	exit 1;
}

if (exists($options{"loadstate"})) {
	if (!load_state($options{"loadstate"})) {
		exit 1;
	}
}

if (exists($options{"startstate"})) {
	$state = $options{"startstate"};
} else {
	if (!$state || $state eq "") {
		$state = "start";
	}
}

if ($state ne "start") {
	update_path($state);
}

eval_state($state);
