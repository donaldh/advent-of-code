#!/usr/bin/env perl6

use v6;

my %orbits;

for '6.txt'.IO.lines -> $line {
    my ($a, $b) = $line.split(')');
    %orbits{$b} = $a;
}

sub to-com($s) {
    return 0 if $s ~~ 'COM';
    return to-com(%orbits{$s}) + 1;
}

my $total = [+] %orbits.keys.map(-> $s { to-com($s) });

say "Part 1";
say $total;

sub ancestors($s is copy) {
    gather {
        while $s !~~ 'COM' {
            $s = %orbits{$s};
            take $s;
        }
    }
}

my @san = ancestors('SAN');
my @you = ancestors('YOU');

sub distance($a, $b) {
    return 0 if $a ~~ $b;
    return distance(%orbits{$a}, $b) + 1;
}

say "Part 2";
my @candidates = (@san (&) @you).keys;
say @candidates.map(-> $s { distance('SAN', $s) + distance('YOU', $s) - 2 }).min;

