#!/usr/bin/env perl6

use v6;

class Claim { has $.id; has $.x; has $.y; has $.w; has $.h; has $.overlap is rw = False; }

my @claims = gather {
    for '3a-input.txt'.IO.lines {
        my ($id, $x, $y, $w, $h) = .match(/ '#' (\d+) \s+ '@' \s+ (\d+) ',' (\d+) ':' \s+ (\d+) 'x' (\d+) /).map: +*;
        take Claim.new(:$id, :$x, :$y, :$w, :$h);
    }
}
say "Parsed in $(now - ENTER now) seconds";

my @fabric[1000;1000];
my $total-overlaps = 0;

{
    for @claims -> $c {
        my $x1 = $c.x + 1;
        my $x2 = $c.x + $c.w;
        my $y1 = $c.y + 1;
        my $y2 = $c.y + $c.h;

        for $x1..$x2 -> $x {
            for $y1..$y2 -> $y {
                my $cell := @fabric[$x;$y];
                $cell = Array.new if ! $cell;
                $cell.push: $c;
                if +$cell == 2 {
                    $total-overlaps += 1;
                }
                if +$cell > 1 {
                    for @($cell) -> $c {
                        $c.overlap = True;
                    }
                }
            }
        }
    }
    say "Executed in $(now - ENTER now) seconds";
}

say "Total overlapping sq/in is {$total-overlaps}";

for @claims -> $c {
    say "Claim {$c.id} is intact" if ! $c.overlap;
}
