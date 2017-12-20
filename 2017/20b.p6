#!/usr/bin/env perl6
use v6;

my $input = '20.txt';

class XYZ {
    has $.x is rw;
    has $.y is rw;
    has $.z is rw;
}

class Particle {
    has $.id;
    has XYZ $.position;
    has XYZ $.velocity;
    has XYZ $.acceleration;

    method update {
        $!velocity.x += $!acceleration.x;
        $!velocity.y += $!acceleration.y;
        $!velocity.z += $!acceleration.z;

        $!position.x += $!velocity.x;
        $!position.y += $!velocity.y;
        $!position.z += $!velocity.z;
    }

    method manhattan {
        $!position.x.abs + $!position.y.abs + $!position.z.abs
    }

    method collides(Particle $o) {
        $!position.x == $o.position.x &&
        $!position.y == $o.position.y &&
        $!position.z == $o.position.z
    }
}

my $id = 0;
my @particles = $input.IO.lines.map: {
    my ($position, $velocity, $acceleration) = .split(', ').map: {
        /'<' ('-'? \d+) ** 3 % ',' '>'/;
        XYZ.new(x => +$0[0], y => +$0[1], z => +$0[2])
    };
    Particle.new(id => $id++, :$position, :$velocity, :$acceleration)
};

(0..40).map(
    {
        @particles.map({ .update });
        my @dups = @particles.repeated(with => { $^a.collides($^b) }).unique(with => { $^a.collides($^b) });
        my @remainder = @particles.grep( -> $p { ! @dups.first({ .collides($p) }) });
        my $collisions = +@particles - +@remainder;
        say "Removed {$collisions} collisions" if $collisions;

        @particles = @remainder;
    }
);

say "There are {+@particles} remaining.";
