#!/usr/bin/env perl6

use v6;

my @box-ids = '2a-input.txt'.IO.lines;
my $twos = 0;
my $threes = 0;

for @box-ids {
    my %bag = .comb.Bag.antipairs;
    $twos += 1 if %bag<2>;
    $threes += 1 if %bag<3>;
}

say "Checksum is {$twos * $threes}";

