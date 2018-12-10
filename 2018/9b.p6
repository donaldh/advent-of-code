#!/usr/bin/env perl6
use v6;

class Circular {
    has int $.value;
    has $.left is rw = self;
    has $.right is rw = self;

    method insert-right(int $value) {
        my $new := Circular.new(:$value, left => self, right => $!right);
        $!right.left = $new;
        $!right = $new;
        $new;
    }

    method remove-left {
        my $remove = $!left;
        $remove.left.right = self;
        $!left = $remove.left;
        $remove;
    }
}

sub play(int $num-players, int $last-marble) {
    say "Playing marble mania for {$num-players} players with {$last-marble} marbles";

    my int @players;
    my $cur-marble = Circular.new(value => 0);

    for 1..$last-marble -> int $to-play {
        my $cur-player := $to-play % $num-players;

        if $to-play %% 23 {
            $cur-marble .= left for ^6;
            my int $removed-value = $cur-marble.remove-left.value;
            @players[$cur-player] += ($to-play + $removed-value);
        } else {
            $cur-marble .= right;
            $cur-marble = $cur-marble.insert-right($to-play);
        }
    }

    say "Winning Elf's score is {@players.max}";
    say "Took $(now - ENTER now) seconds";
}

# play(9, 25);
# play(13, 7999);
# play(30, 5807);

my ($num-players, $last-marble) = '9-input.txt'.IO.comb(/\d+/)>>.Int;
play($num-players, $last-marble);
play($num-players, $last-marble * 100);
