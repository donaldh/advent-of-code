#!/usr/bin/env perl6
use v6;

my $input = slurp '13.txt';

my %scanners;

for $input.lines {
    /^ (\d+) ': ' (\d+) /;
    %scanners{$0} = { 'range' => +$1, 'pos' => 0, 'down' => True };
}

my $max-depth = max %scanners.keys.map: { .Int };
my @severities[$max-depth + 1];

for 0..* -> $pico {

    @severities[0] = 0;

    my $dist = min($pico, $max-depth);
    for 0..$dist -> $d {
        if %scanners{$d} && %scanners{$d}<pos> == 0 {
            @severities[$d] += $d * %scanners{$d}<range>;
        }
    }

    #say "Time {$pico - $max-depth} {@severities[$max-depth] ?? @severities[$max-depth] !! ''}";
    say "Time {$pico}" if $pico %% 1000;

    if @severities[$max-depth] && @severities[$max-depth] == 0 {
        say "Leaving at time {$pico - $max-depth} incurs zero severity";
        exit;
    }

    advance;
    @severities .= rotate(-1);
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
