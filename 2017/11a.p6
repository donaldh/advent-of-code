#!/usr/bin/env perl6
use v6;

my $input = slurp('11.txt').chomp;

my $x = 0;
my $y = 0;

for $input.split(',') -> $move {
    given $move {
        when 'nw' {
            $x -= 0.5;
            $y += 0.5;
        }
        when 'n' {
            $y += 1;
        }
        when 'ne' {
            $x += 0.5;
            $y += 0.5;
        }
        when 'se' {
            $x += 0.5;
            $y -= 0.5;
        }
        when 's' {
            $y -= 1;
        }
        when 'sw' {
            $x -= 0.5;
            $y -= 0.5;
        }
    }
}

say "Child is {$x.abs + $y.abs} steps away";
