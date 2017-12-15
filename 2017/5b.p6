#!/usr/bin/env perl6
use v6;

my $input = slurp '5.txt';

my Int @instructions = $input.lines>>.Int;
my Int $many = +@instructions;

my Int $pos = 0;
my Int $steps = 0;

while 0 <= $pos < $many {

    my $jump := @instructions.AT-POS($pos);
    $pos = $pos + $jump;
    if $jump >= 3 {
        $jump = $jump - 1;
    } else {
        $jump = $jump + 1;
    }
    $steps = $steps + 1;
}

say "Escaped in {$steps} steps";

my $duration = now - BEGIN { now }
say "Took {$duration} seconds";
