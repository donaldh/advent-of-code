#!/usr/bin/env perl6
use v6;

my $goal = 368078;

my @sums[1000;1000];
@sums[500;500] = 1;

my $x = 0;
my $y = 0;
my $pos = 1;

for 1..* -> $a, $b {

    # Right
    for 1..$a {
        $x++;
        $pos++;
        check($pos);
    }

    # Up
    for 1..$a {
        $y++;
        $pos++;
        check($pos);
    }

    # Left
    for 1..$b {
        $x--;
        $pos++;
        check($pos);
    }

    # Down
    for 1..$b {
        $y--;
        $pos++;
        check($pos);
    }
}

sub check($pos) {
    state $said = False;
    if not $said {
        my $sx = $x + 500;
        my $sy = $y + 500;

        my $sum =
        (@sums[$sx - 1; $sy] // 0) +
        (@sums[$sx - 1; $sy - 1] // 0) +
        (@sums[$sx; $sy - 1] // 0) +
        (@sums[$sx + 1; $sy - 1] // 0) +
        (@sums[$sx + 1; $sy] // 0) +
        (@sums[$sx + 1; $sy + 1] // 0) +
        (@sums[$sx; $sy + 1] // 0) +
        (@sums[$sx - 1; $sy + 1] // 0);

        @sums[$sx; $sy] = $sum;

        if $sum > $goal {
            say "{$sum} is greater than {$goal}";
            $said = True;
        }
    }

    if $pos == $goal {
        my $steps = abs($x) + abs($y);
        say "{$steps} steps to access location {$goal}";
        exit;
    }
}
