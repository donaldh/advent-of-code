#!/usr/bin/env perl6
use v6;

class Guard {
    has $.id;
    has int @.sleep[60];
    has $.fall;

    method fall(Int $t) { $!fall = $t; }
    method wake(Int $t) {  @!sleep[$_] += 1 for $!fall..^$t; }
    method totes { [+] @!sleep; }
    method max { @!sleep.max; }
    method gist { "Guard #{$!id} – { [+] @!sleep } – {@!sleep}"; }

    method show {
        my $max = @!sleep.maxpairs[0];
        say '';
        say "Guard #{$!id} had {$max.value} sleeps in minute {$max.key}";
        say "Giving {$!id * $max.key}";
    }
}

my %guards;

for '4a-input.txt'.IO.lines.sort -> $event {
    my ($mm, $act) = $event.match(/ ':' (\d+) ']' \s (.*) /).map: ~*;

    state $current;
    given $act {
        when /'Guard #' (\d+)/ {
            my $id = ~$/[0];
            $current = %guards{$id} //= Guard.new(:$id);
        }
        when /'falls asleep'/ {
            $current.fall(+$mm);
        }
        when /'wakes up'/ {
            $current.wake(+$mm);
        }
    }
}

# Part One
%guards.values.max(*.totes).show;

# Part Two
%guards.values.max(*.max).show;
