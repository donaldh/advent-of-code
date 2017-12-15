#!/usr/bin/env perl6
use v6;

my $input = slurp('1.txt').chomp;
my $chars = $input.comb;
my $length = $input.chars;

my $total = 0;

for 0..^$length -> $i {

    my $c1 = $chars[$i];
    my $c2 = $chars[($i + 1) mod $length];

    $total += +$c1 if $c1 eq $c2;
}

say $total;
