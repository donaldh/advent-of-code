#!/usr/bin/env perl6
use v6;

# my $num-players = 9; my $last-marble = 25;
# my $num-players = 30; my $last-marble = 5807;
my ($num-players, $last-marble) = '9-input.txt'.IO.comb(/\d+/);

say "Playing marbles for {$num-players} players with {$last-marble} marbles";

my @players;
my @marbles = 0;
my $cur-marble = 0;

for 1..$last-marble -> $to-play {
    my $cur-player = $to-play % $num-players;

    if $to-play %% 23 {
        $cur-marble = (+@marbles + $cur-marble - 7) % +@marbles;
        @players[$cur-player] += ($to-play + @marbles[$cur-marble]);
        @marbles = slip(@marbles[0..^$cur-marble]), slip(@marbles[$cur-marble+1..*]);
    } else {
        my $pos = ($cur-marble + 1) % +@marbles;
        @marbles = slip(@marbles[0..$pos]), $to-play, slip(@marbles[$pos+1..*]);
        $cur-marble = ($pos + 1) % +@marbles;
    }
}

say @players.max;
say "Took $(now - ENTER now) seconds";
