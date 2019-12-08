#!/usr/bin/env perl6

use v6;

class Move {
    has Int $.dx;
    has Int $.dy;

    method create(Str $m) {
        my $dir = $m.substr(0,1);
        my $dist = $m.substr(1);

        given $dir {
            when 'R' {
                return Move.new(dx=> +$dist, dy=>0);
            }
            when 'L' {
                return Move.new(dx=> -$dist, dy=>0);
            }
            when 'U' {
                return Move.new(dx=>0, dy=> +$dist);
            }
            when 'D' {
                return Move.new(dx=>0, dy=> -$dist);
            }
        }
    }
}

class Point {
    has Int $.x;
    has Int $.y;
}

class Line {
    has Point $.a;
    has Point $.z;

    method horizontal {
        $!a.y == $!z.y;
    }

    method vertical {
        $!a.x == $!z.x;
    }
}

my @wires = gather {
    for '3.txt'.IO.lines -> $line {
        my @moves = $line.split(',').map( -> $m { Move.create($m) });

        my @lines;
        my $a = Point.new(x=>0, y=>0);
        for @moves -> $m {
            my $z = Point.new(x => $a.x + $m.dx, y => $a.y + $m.dy);
            @lines.push: Line.new(:$a, :$z);
            $a = $z;
        }
        take @lines;
    }
}

sub intersection(Line $l1, Line $l2) {

    if $l1.horizontal && $l2.vertical &&
    $l1.a.x <= $l2.a.x <= $l1.z.x &&
    $l2.a.y <= $l1.a.y <= $l2.z.y {
        return $l2.a.x, $l1.a.y;
    }

    if $l1.vertical && $l2.horizontal &&
    $l2.a.x <= $l1.a.x <= $l2.z.x &&
    $l1.a.y <= $l2.a.y <= $l1.z.y {
        return $l1.a.x, $l2.a.y;
    }
}

my @intersections = gather {
    for flat @wires[0] -> $l1 {
        for flat @wires[1] -> $l2 {
            take intersection($l1, $l2)
        }
    }
}

say @intersections.map(-> $i { abs($i[0]) + abs($i[1]) }).min;
