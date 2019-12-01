#!/usr/bin/env perl6

use v6;

sub fuel-required(Int $mass) { $mass div 3 - 2 }

my $total-mass = [+] '1a.txt'.IO.lines.map(-> $m { fuel-required($m.Int) });

say $total-mass;

#say fuel-required(100756);
