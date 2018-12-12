#!/usr/bin/env perl6
use v6;

my $serial = 3214;

my int @grid[301;301];

for 1..300 -> int $y {
    for 1..300 -> int $x {
        my int $rack-id = $x + 10;
        my int $power = (((($rack-id * $y) + $serial) * $rack-id) % 1000 div 100) - 5;
        @grid[$x;$y] = $power;
    }
}

my int $mx;
my int $my;
my int $ms;
my int $max = 0;

sub search($size) {
    say "Checking {$size}";
    for 1..(301-$size) -> int $y {
        for 1..(301-$size) -> int $x {

            my int $sum = 0;
            for ^$size -> $dx {
                for ^$size -> $dy {
                    $sum += @grid[$x+$dx;$y+$dy];
                }
            }

            if $sum > $max {
                say "{$x},{$y},{$size} -> {$sum}";
                $max = $sum;
                $mx = $x;
                $my = $y;
                $ms = $size;
            }
        }
    }
}

say "Part 1";
search 3;
say "Part 2";
for 4..20 -> $x { search $x };
