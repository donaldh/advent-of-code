#!/usr/bin/env perl6

use v6;

my $input = slurp '6.txt';

my @bags[8] = Bag.new, Bag.new, Bag.new, Bag.new, Bag.new, Bag.new, Bag.new, Bag.new;

for $input.lines {
    for flat .comb Z 0..* -> $c, $i {
        @bags[$i] = @bags[$i] (+) $c;
    }
}

join('',
     @bags.map(
         {.sort({$^a.value <=> $^b.value}).head.key }
     )
    ).say;
