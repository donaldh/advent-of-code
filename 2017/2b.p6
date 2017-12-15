#!/usr/bin/env perl6
use v6;

my $input = slurp '2.txt';

my $total = 0;

for $input.lines {
    my @cells = .split(/\s+/);
    for @cells.combinations(2) -> @pair {
        my ($a, $b) = @pair.sort(&infix:«<=>»);
        if $b %% $a {
            $total += $b / $a;
        }
    }
}
say "Sum of evenly divisible values is {$total}";
