#!/usr/bin/env perl6

use v6;

my $input = slurp '7.txt';

enum <Positive Negative Ignore>;

my $total = 0;

for $input.lines -> $line {

    my $m = $line.match(
        / [
            ^ [ .* ']' ]? <-[\[]>*
            (.) (.) <?{ $0 ne $1 }> :my ($a, $b) = $0, $1; $a
            <-[\]]>* [ '[' .* ]? $
          ]
        &&
          [
            .* '[' <-[\]]>* <( $b $a $b )> <-[\]]>* ']' .*
          ] /
    );
    if $m {
        my @pad = ($m.from, $m[0].from).sort;
        @pad[1] -= @pad[0] + 3;

        say $line;
        say "{' ' x @pad[0]}^^^{'-' x @pad[1]}^^^";

        $total++;
    }
}

say $total;
