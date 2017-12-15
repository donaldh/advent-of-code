#!/usr/bin/env perl6
use v6;

my $input = slurp '13.txt';

my %scanners;

for $input.lines {
    /^ (\d+) ': ' (\d+) /;
    %scanners{$0} = { 'range' => +$1, 'pos' => 0, 'down' => True };
}


my $max-depth = max %scanners.keys;

for 0..* -> $time {

    %scanners.values.map: { $_<pos> = 0; $_<down> = True; };

    for 0..^$time {
        advance;
    }

    my $severity = 0;
    for 0..$max-depth -> $d {
        if %scanners{$d} && %scanners{$d}<pos> == 0 {
            $severity += $d * %scanners{$d}<range>;
        }
        advance;
    }

    say "Leaving at time {$time} incurs severity {$severity}";
    exit if $severity == 0;
}

sub advance() {
    for %scanners.values -> $v {
        if $v<down> {
            if $v<pos> < $v<range> - 1 {
                $v<pos> += 1;
            }
            if $v<pos> == $v<range> - 1 {
                $v<down> = False;
            }
        } else {
            if $v<pos> > 0 {
                $v<pos> -= 1;
            }
            if $v<pos> == 0 {
                $v<down> = True;
            }
        }
    }
}
