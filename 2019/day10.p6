#!/usr/bin/env perl6

use v6;

my @grid[42;42] = '10.txt'.IO.lines.map(*.comb);

class Point { has $.x; has $.y; }

my @locations = gather {
    for ^42 -> $y {
        for ^42 -> $x {
            take Point.new(:$x, :$y) if @grid[$y;$x] ne '.';
        }
    }
}

sub sight-lines(Point $origin) {
    my @relative-locations = @locations.map(
        -> $p {
            Point.new(x => $p.x - $origin.x, y => $p.y - $origin.y)
        });
    my $unique = @relative-locations.grep(
        -> $p {
            $p.x != 0 || $p.y != 0
        }).map(
        -> $p {
            my $gcd = $p.x gcd $p.y;
            "{$p.x / $gcd},{$p.y / $gcd}"
        }).Bag;
    +$unique.keys
}

my @visible = @locations.race.map( -> $origin { sight-lines($origin) });

say @visible;

say "Part 1";
say @visible.max;
