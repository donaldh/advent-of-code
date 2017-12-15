#!/usr/bin/env perl6

use v6;

my $input = slurp '4.txt';

my @chars = 'a'..'z';

for $input.lines {
    / (<[a..z-]>+) '-' (\d+) '[' (\w+) ']' /;

    my $words = $0;
    my $sector = +$1;
    my $wanted-checksum = $2;

    my $frequency = bag $words.trans(/'-'/ => '').comb;
    my $sorted = $frequency.sort({$^b.value <=> $^a.value || $^a.key leg $^b.key});
    my $checksum = $sorted.head(5).map({.key}).join;

    my $rot = $sector mod 26;
    my @rot-chars = flat @chars.tail(26 - $rot), @chars.head($rot);
    $words .= trans(@chars => @rot-chars, '-' => ' ');

    say "{$words} => {$sector}" if $checksum eq $wanted-checksum and $words ~~ /'north'/;
}
