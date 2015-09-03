#!/usr/bin/perl

use strict;
use warnings;
use IO::Prompter;
use FSM::Simple;
use advgame;
    
my $machine = FSM::Simple->new();

$machine->add_state(name => "init", sub => \&do_init);
$machine->add_state(name => "get_gender", sub => \&do_get_gender);
$machine->add_state(name => "walking01", sub => \&do_walking01);
$machine->add_state(name => "walking02", sub => \&do_walking02);
$machine->add_state(name => "walking03", sub => \&do_walking03);
$machine->add_state(name => "walking04", sub => \&do_walking04);
$machine->add_state(name => "noise", sub => \&do_noise);
$machine->add_state(name => "hide", sub => \&do_hide);
$machine->add_state(name => "jeep", sub => \&do_jeep);
$machine->add_state(name => "end_walk", sub => \&do_end_walk);
$machine->add_state(name => "ride", sub => \&do_ride);
$machine->add_state(name => "hospital", sub => \&do_hospital);

$machine->add_state(name => "end", sub => \&do_end);

$machine->add_trans(from => "init", to => "get_gender",  exp_val => 1);
$machine->add_trans(from => "get_gender", to => "walking01",  exp_val => 1);
$machine->add_trans(from => "walking01", to => "walking02",  exp_val => 1);
$machine->add_trans(from => "walking02", to => "walking03",  exp_val => 1);
$machine->add_trans(from => "walking03", to => "walking04",  exp_val => 1);
$machine->add_trans(from => "walking04", to => "noise",  exp_val => 1);
$machine->add_trans(from => "noise", to => "hide",  exp_val => "hide");
$machine->add_trans(from => "noise", to => "jeep",  exp_val => "wait");
$machine->add_trans(from => "hide", to => "jeep",  exp_val => "hide");
$machine->add_trans(from => "jeep", to => "end_walk",  exp_val => "decline");
$machine->add_trans(from => "jeep", to => "ride",  exp_val => "accept");
$machine->add_trans(from => "ride", to => "hospital",  exp_val => 1);
# This will change as we go foarward. XXX
$machine->add_trans(from => "hospital", to => "end",  exp_val => 1);

$machine->run();

sub do_init {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: init\n";
	}

	advgame::usage();
	my $ans = advgame::get_prompt("Press enter to continue.\n");

	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_get_gender {
	my $rh_args = shift;
	my $gender = "";

	if (query_debug()) {
		print "State: get_gender\n";
	}

	while (($gender ne "male") && ($gender ne "female")) {
		$gender = advgame::get_prompt("Would you like to play the " .
			"game as a male or female? ");
	}
	$rh_args->{"gender"} = $gender;

	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_walking01 {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: walking01\n";
	}

	print "You have been walking for quite awhile now.\n";

	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_walking02 {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: walking02\n";
	}

	print "This is a crappy day.\n";
	my $ans = advgame::get_prompt("Press enter to continue.\n");

	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_walking03 {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: walking03\n";
	}

	if ($rh_args->{"gender"} eq "male") {
		print "Man it sure is hot.\n";
	} else {
		print "Wow, it sure is hot.\n";
	}

	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_walking04 {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: walking04\n";
	}

	print "This could be a long day.\n";

	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_noise {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: noise\n";
	}
	
	print "You hear an engine in the distance.\n";

	my $ans = advgame::get_prompt("What would you like to do?\n\thide\n" .
		"\tsignal\n\twait\n\n");

	if ($ans eq "hide") {
		$rh_args->{"returned_value"} = "hide";
	} else {
		$rh_args->{"returned_value"} = "wait";
	}

	print "You $ans.\n";

	return $rh_args;
}

sub do_hide {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: hide\n";
	}
	
	print "After a few minutes, the jeep pulls up to close to where you " .
		"are hiding.\n";
	print "The window rolls down.";
	print "A man inside the jeep yells at you:  \"Funny thing about the " .
		"desert.  You can see for miles.  I saw you jump behind the " .
		"rocks.\"\n";

	$rh_args->{"returned_value"} = "hide";

	return $rh_args;
}

sub do_jeep {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: jeep\n";
	}

	if ($rh_args->{"gender"} eq "male") {
		print "Hey Man!\n";
	} else {
		print "Hello!\n";
	}
# XXX Need to do some extra stuff here for non hide

	my $ans = advgame::get_prompt("Do you want a lift? " .
		"[accept | decline] \n");
	if ($ans eq "accept") {
		$rh_args->{"returned_value"} = "accept";
	} else {
		$rh_args->{"returned_value"} = "decline";
	}

	return $rh_args;
}

sub do_end_walk {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: end_walk\n";
	}
	
	print "You continue on your walk, later you pass out from heat " .
		"exhaustion.\n";
	print "The end!.\n";

	$rh_args->{"returned_value"} = undef; # stop condition!!!

	return $rh_args;
}

sub do_ride {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: ride\n";
	}

	print "You climb into the jeep!\n";
	print "You feel sleepy? XXX more needed here.\n";
	
	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_hospital {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: hospital\n";
	}

	print "You wake up briefly, you are confused.\n";
	
	$rh_args->{"returned_value"} = 1;
	return $rh_args;
}

sub do_end {
	my $rh_args = shift;

	if (query_debug()) {
		print "State: end\n";
	}

	print "There is more to the story, you'll have to wait to see more.\n";

	$rh_args->{"returned_value"} = undef;
	return $rh_args;
}
