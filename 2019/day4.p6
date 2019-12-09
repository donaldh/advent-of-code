#!/usr/bin/env perl6

use v6;

my @range = 256310..732736;

sub MAIN(:$start = 256310, :$end = 732736, :$spill = False) {
    my @part1 = ($start..$end)
    .grep(-> $i { [<=] $i.comb })
    .grep(-> $i { $i ~~ / (\d) $0 / });

    @part1.rotor(20, :partial).map(*.say) if $spill;

    say "Part 1";
    say +@part1;

    my @part2 = @part1.grep(-> $s { $s.comb(/(\d) $0*/).grep(*.chars == 2) });

    @part2.rotor(20, :partial).map(*.say) if $spill;

    say "Part 2";
    say +@part2;
}
