#!/usr/bin/env perl6
use v6;

my %dependencies .= append: '7-input.txt'.IO.lines.comb(/ « <[A..Z]> » /);
for ([⊎] %dependencies.values).keys -> $k { %dependencies{$k} //= Array.new }

sub calculate($num-workers, %deps is copy) {
    my $duration;
    my @ordered-steps = gather {
        my %work;
        while +%deps > 0 {
            my @next = ((%deps.keys ∖ [⊎] %deps.values).keys.sort ∖ %work.keys).keys.sort;

            my $free = $num-workers - +%work;
            for @next.splice(0, $free) -> $s { %work{$s} = 60 + ($s.ord - 64); }

            my $timestep = %work.values.min;
            %work = %work.kv.map(* => * - $timestep);
            my @done = %work.grep(*.value == 0).hash.keys;

            %work{@done}:delete;
            %deps{@done}:delete;

            $duration += $timestep;
            take $_ for @done.sort;
        }
    }
    say "{@ordered-steps.join} in {$duration} seconds with {$num-workers} workers";
}

calculate(1, %dependencies);
calculate(5, %dependencies);
