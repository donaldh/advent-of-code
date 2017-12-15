#!/usr/bin/env perl6
use v6;

my $input = slurp '2.txt';

my $total = 0;

for $input.lines {
    my @cells = .split(/\s+/).map( +* ).sort;
    my $line-ck = @cells.pop - @cells.shift;
    $total += $line-ck;
}
say "Checksum is {$total}";
