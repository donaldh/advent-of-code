#!/usr/bin/env perl6

use v6;

my $input = slurp '4.txt';

my $sum = 0;

for $input.lines {
    / (<[a..z-]>+) '-' (\d+) '[' (\w+) ']' /;

    my $words = $0;
    my $sector = +$1;
    my $wanted-checksum = $2;

    my $frequency = bag($words.trans(/'-'/ => '').comb);
    my $sorted = $frequency.sort({$^b.value <=> $^a.value || $^a.key leg $^b.key});
    my $checksum = $sorted.head(5).map({.key}).join;

    $sum += $sector if $checksum eq $wanted-checksum;
}

say "Sum of sector ids is {$sum}";
