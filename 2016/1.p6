#!/usr/bin/env perl6

use v6;

my $input = "L2, L5, L5, R5, L2, L4, R1, R1, L4, R2, R1, L1, L4, R1, L4, L4, R5, R3, R1, L1, R1, L5, L1, R5, L4, R2, L5, L3, L3, R3, L3, R4, R4, L2, L5, R1, R2, L2, L1, R3, R4, L193, R3, L5, R45, L1, R4, R79, L5, L5, R5, R1, L4, R3, R3, L4, R185, L5, L3, L1, R5, L2, R1, R3, R2, L3, L4, L2, R2, L3, L2, L2, L3, L5, R3, R4, L5, R1, R2, L2, R4, R3, L4, L3, L1, R3, R2, R1, R1, L3, R4, L5, R2, R1, R3, L3, L2, L2, R2, R1, R2, R3, L3, L3, R4, L4, R4, R4, R4, L3, L1, L2, R5, R2, R2, R2, L4, L3, L4, R4, L5, L4, R2, L4, L4, R4, R1, R5, L2, L4, L5, L3, L2, L4, L4, R3, L3, L4, R1, L2, R3, L2, R1, R2, R5, L4, L2, L1, L3, R2, R3, L2, L1, L5, L2, L1, R4";

enum Compass <North East South West>;

my @commands = $input.split(/<[,\s]>+/);
my Compass $facing = North;
my Int $northing = 0;
my Int $easting = 0;

my @visited[1000; 1000];

for @commands -> $c {
    my ($turn, $paces) = $c.comb: /\D+||\d+/;

    given $turn {
        when 'L' {
            $facing = Compass(($facing + 3) % 4);
        }
        when 'R' {
            $facing = Compass(($facing + 1) % 4);
        }
    }
    go($facing, $paces);
}

sub go(Compass $direction, $paces) {
    for 1..$paces {
        given $direction {
            when North {
                $northing++;
            }
            when East {
                $easting++;
            }
            when South {
                $northing--;
            }
            when West {
                $easting--;
            }
        }
        check($easting, $northing);
    }
}

sub check($easting, $northing) {
    my $been-there = @visited[$easting + 500; $northing + 500] // False;
    if $been-there {
        say "Visited {$easting, $northing} before";

        my $distance = $easting.abs + $northing.abs;
        say "Distance is {$distance}";

        exit;
    }
    @visited[$easting + 500;$northing + 500] = True;
}
