#!/usr/bin/env perl6
use v6;

class Particle {
    has Int $.x; has Int $.y; has Int $.vx; has Int $.vy;
    method move { $!x += $!vx; $!y += $!vy; self; };
}

my @particles = '10-input.txt'.IO.comb(/'-'? \d+/).map(+*).map(
    -> $x, $y, $vx, $vy { Particle.new(:$x, :$y, :$vx, :$vy); }
);

sub draw {
    my $xrange = @particles.minmax(*.x);
    my $yrange = @particles.minmax(*.y);

    for $yrange.min.y .. $yrange.max.y -> $y {
        for $xrange.min.x .. $xrange.max.x -> $x {
            print @particles.grep(-> $p { $p.x == $x and $p.y == $y }) ?? '#' !! '.';
        }
        say '';
    }
}

for 1..* -> $iter {
    .move for @particles;

    my $y-bound = @particles.max(*.y).y - @particles.min(*.y).y;
    if $y-bound < 12 {
        say $iter;
        draw;
        last;
    }
}
