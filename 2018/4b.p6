#!/usr/bin/env perl6

use v6;

my @events = '4a-input.txt'.IO.lines.sort;
my %guards;

class Guard {
    has $.id;
    has int @.sleep[60];
    has $.fall;

    method fall(Int $t) {
        $!fall = $t;
    }

    method wake(Int $t) {
        for $!fall..^$t -> $minute {
            @!sleep[$minute] += 1;
        }
    }

    method totes {
        [+] @!sleep;
    }

    method max {
        @!sleep.sort(-*).head;
    }

    method display {
        say "Guard #{$!id} – { [+] @!sleep } – {@!sleep}";
    }

    method show {
        my @max = @!sleep.maxpairs;
        my $p = @max[+@max / 2];
        say '';
        say "Guard #{$!id} had {$p.value} sleeps in minute {$p.key}";
        say "Giving {$!id * $p.key}";
        say '';
    }
}

my $current;
for @events -> $e {
    my ($y, $m, $d, $hh, $mm, $act) = $e.match(
        /'[' (\d+) '-' (\d+) '-' (\d+) \s (\d+) ':' (\d+) ']' \s (.*) /
    ).map: ~*;

    given $act {
        when /'Guard #' (\d+)/ {
            my $id = ~$/[0];
            $current = %guards{$id} // Guard.new(:$id);
            %guards{$id} = $current;
        }
        when /'falls asleep'/ {
            $current.fall(+$mm);
        }
        when /'wakes up'/ {
            $current.wake(+$mm);
        }
    }
}

{ # Part One
    my @sorted = %guards.values.sort: -*.totes;
    .display for @sorted;
    @sorted.head.show;
}

{ # Part Two
    my @sorted = %guards.values.sort: -*.max;
    .display for @sorted;
    @sorted.head.show;
}

