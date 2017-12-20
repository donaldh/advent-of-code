#!/usr/bin/env perl6
use v6;

my $input = 316;

my @buffer = 0;
my $index = 0;

for 1..2017 -> $i {
    $index = ($index + $input) % +@buffer;

    @buffer = flat @buffer[0..$index], $i, @buffer[$index+1 .. *];
    $index++;
}

say @buffer[$index+1];
