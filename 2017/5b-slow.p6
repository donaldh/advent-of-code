#!/usr/bin/env perl6
use v6;

my $input = slurp '5.txt';

my @instructions = $input.lines>>.Int;
my $many = +@instructions;

my $pos = 0;
my $steps = 0;

while 0 <= $pos < $many {

    my $jump = @instructions[$pos];
    if $jump >= 3 {
        @instructions[$pos]--;
    } else {
        @instructions[$pos]++;
    }
    $pos += $jump;
    $steps++;
}

say "Escaped in {$steps} steps";

my $duration = now - BEGIN { now }
say "Took {$duration} seconds";
