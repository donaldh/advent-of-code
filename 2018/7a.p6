#!/usr/bin/env perl6
use v6;

my %deps;
for '7-input.txt'.IO.lines {
    my ($k, $v) = .comb(/ « <[A..Z]> » /);
    %deps{$k} //= SetHash.new;
    %deps{$v} //= SetHash.new;
    %deps{$k}{$v} = True;
}

my @ordered-steps = gather {
    while +%deps > 0 {
        my $next = (%deps.keys (-) [(+)] %deps.values).keys.sort.head;
        %deps{$next}:delete;
        take $next;
    }
}

say @ordered-steps.join;
