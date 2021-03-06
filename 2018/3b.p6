#!/usr/bin/env perl6

use v6;

my %claims = gather {
    for '3a-input.txt'.IO.lines {
        my $m = .match: / '#' $<id>=\d+ \s+ '@' \s+ $<x>=\d+ ',' $<y>=\d+ ':' \s+ $<w>=\d+ 'x' $<h>=\d+ /;
        take ~$<id> => %('id' => ~$<id>, 'x' => ~$<x>, 'y' => ~$<y>, 'w' => ~$<w>, 'h' => ~$<h>);
    }
}

my @fabric[1000;1000];

my $total-overlaps = 0;

for %claims.values -> %c {
    my $x1 = %c<x> + 1;
    my $x2 = %c<x> + %c<w>;
    my $y1 = %c<y> + 1;
    my $y2 = %c<y> + %c<h>;

    for $x1..$x2 -> $x {
        for $y1..$y2 -> $y {
            @fabric[$x;$y].push: %c<id>;
            if +@fabric[$x;$y] == 2 {
                $total-overlaps += 1;
            }
            if +@fabric[$x;$y] > 1 {
                for @(@fabric[$x;$y]) -> $id {
                    %(%claims{$id})<overlapped> = True;
                }
            }
        }
    }
}

say "Total overlapping sq/in is {$total-overlaps}";

for %claims.values -> %c {
    say "Claim {%c<id>} is intact" if ! %c<overlapped>;
}
