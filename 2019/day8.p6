#!/usr/bin/env perl6

use v6;

my @digits = slurp('8.txt').comb;
my $total-pixels = 25 * 6;

my @layers = @digits.rotor($total-pixels);

my @min = flat @layers.min(-> @l { +@l.grep(/0/) });

say "Part 1";
say +@min.grep(/1/) * +@min.grep(/2/);

my @image[6;25];

for @layers -> @l {
    my @rows = @l.rotor(25);

    for ^6 -> $row {
        my @row = flat @rows[$row];
        for ^25 -> $col {
            my $cell = @row[$col];
            @image[$row;$col] //= $cell;
            @image[$row;$col] = $cell if @image[$row;$col] == 2;
        }
    }
}

sub draw {
    say '';
    for ^6 -> $row {
        for ^25 -> $col {
            given @image[$row;$col] {
                when 0 { print '.'; }
                when 1 { print ''; }
                when 2 { print ' '; }
            }
        }
        say '';
    }
}

say "Part 2";
draw;
