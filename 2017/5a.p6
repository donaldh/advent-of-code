#!/usr/bin/env perl6
use v6;

my $input = slurp '5.txt';

my int @instructions = $input.lines.map: { +$_ };
my $many = +@instructions;

my $pos = 0;
my $steps = 0;

while 0 <= $pos < $many {

    my $jump = @instructions[$pos]++;
    $pos += $jump;
    $steps++;
}

say "Escaped in {$steps} steps";

my $duration = now - BEGIN { now }
say "Took {$duration} seconds";
