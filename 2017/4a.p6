#!/usr/bin/env perl6
use v6;

my $input = slurp '4.txt';

my $total = 0;

for $input.lines -> $line {
    my @words = $line.split: /\s+/;
    my %anti = bag(@words).antipairs;
    %anti<1>:delete;
    $total++ if +%anti == 0;
}

say "There are {$total} valid passphrases";
