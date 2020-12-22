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

sub visible(Point $origin) {
    my @relative-locations = @locations.map(
        -> $p {
            Point.new(x => $p.x - $origin.x, y => $p.y - $origin.y)
        }).grep(
        -> $p {
            $p.x != 0 || $p.y != 0
        });
    my $unique = @relative-locations.map(
        -> $p {
            my $gcd = $p.x gcd $p.y;
            "{$p.x / $gcd},{$p.y / $gcd}"
        }).Bag;
    [+$unique.keys, $origin, [@relative-locations]]
}

my @visible = @locations.race.map( -> $origin { visible($origin) });
my ($max, $location, $others) = flat @visible.max(*[0]);

say "Part 1";
say $max;

sub rads($x, $y) { my $arc = atan($y / abs($x)); $x < 0 ?? pi - $arc !! $arc }

$others.flat.sort(rads(*.x, *.y), sqrt(*.x ** 2 + *.y ** 2)).say;

