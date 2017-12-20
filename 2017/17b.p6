#!/usr/bin/env perl6
use v6;

my $input = 316;

my $len = 1;
my $index = 0;

my $saved = 0;

for 1..50_000_000 -> $i {
    $index = ($index + $input) % $len;

    $saved = $i if $index == 0;

    $len++;
    $index++;
}

say $saved;
