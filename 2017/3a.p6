#!/usr/bin/env perl6
use v6;

my $goal = 368078;

enum <Up Down Left Right>;

my $dir = Right;
my $pos = 1;
my @sums[1000;1000];

my $x = 0;
my $y = 0;

for 1..* -> $n {

    given $dir {
        when Right {
            for 1..$n {
                $x++;
                $pos++;
                check($pos);
            }
            $dir = Up;
            for 1..$n {
                $y++;
                $pos++;
                check($pos);
            }
            $dir = Left;
        }
        when Left {
            for 1..$n {
                $x--;
                $pos++;
                check($pos);
            }
            $dir = Down;
            for 1..$n {
                $y--;
                $pos++;
                check($pos);
            }
            $dir = Right;
        }
    }
}

sub check($pos) {
    if $pos == $goal {
        say "Goal reached at {$x}, {$y}";
        my $steps = abs($y) + abs($x);
        say "Goal is {$steps} steps from centre";
        exit;
    }
}
