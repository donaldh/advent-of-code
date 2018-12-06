#!/usr/bin/env perl6
use v6;

class Coord {
    has $.name;
    has Int $.x;
    has Int $.y;
    has Int $.distance is rw = 0;
    has Int $.area is rw = 0;
    has Bool $.edge is rw = False;
}

my %coords = gather {
    for '6-input.txt'.IO.lines Z (flat 'a' .. 'z', 'A' .. 'Z') -> ($line, $name) {
        my ($x, $y) = $line.comb(/\d+/)>>.Int;
        take $name => Coord.new(:$name, :$x, :$y);
    }
}

my ($min-x, $max-x) = %coords.values.min(*.x).x, %coords.values.max(*.x).x;
my ($min-y, $max-y) = %coords.values.min(*.y).y, %coords.values.max(*.y).y;

sub distance($ax, $ay, $bx, $by) {
    abs($ax - $bx) + abs($ay - $by);
}

for $min-y .. $max-y -> $y {
    for $min-x .. $max-x -> $x {
        my @d = %coords.values.map({distance($x,$y, .x, .y), $_});
        my $d = @d.min(*[0])[0];

        my @min = @d.grep: *[0] == $d;
        if +@min == 1 {
            my $c = @min.head[1];
            $c.area += 1;
            $c.distance = $d if $d > $c.distance;
            $c.edge = True if $x == $min-x || $x == $max-x || $y == $min-y || $y == $max-y;
        }
    }
}

say %coords.values.grep(*.edge == False).max(*.area).area;
