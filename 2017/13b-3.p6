#!/usr/bin/env perl6
use v6;

my $input = slurp '13.txt';

my %scanners;

for $input.lines {
    /^ (\d+) ': ' (\d+) /;
    my $moves = (+$1 - 1) * 2;
    %scanners{$0} = $moves;
}

my $max-depth = max %scanners.keys.map: { .Int };

for 0..* -> $delay {

    say "Delay {$delay}" if $delay %% 100000;

    my $failed = False;

    for 0..$max-depth -> $d {
        if %scanners{$d} {
            my $pos = ($delay + $d) % %scanners{$d};

            if $pos == 0 {
                $failed = True;
                last;
            }
        }
    }

    unless $failed {
        say "Delaying {$delay} gets through";
        last;
    }
}

my $duration = now - BEGIN { now };
say "Took {$duration} s";
