#!/usr/bin/env perl6

use v6;

sub fuel-required(Int $mass) {
    my Int $fuel = max($mass div 3 - 2, 0);
    $fuel > 0 ?? $fuel + fuel-required($fuel) !! 0
}

#say fuel-required(100756);

my $total-mass = [+] '1a.txt'.IO.lines.map(-> $m { fuel-required($m.Int) });
say $total-mass;
