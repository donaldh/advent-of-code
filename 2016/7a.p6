#!/usr/bin/env perl6

use v6;

my $input = slurp '7.txt';

enum <Positive Negative Ignore>;

for $input.lines {
    my @stats =
    .split(/ '[' <-[\]]>+ ']'/, :v)
    .map( {
if .match(/ [ (.) (.) <?{ $0 ne $1 }> :my $a = $0; :my $b = $1; ($b) ($a) ] /, :global) {
    if .match(/'['/) { Negative } else { Positive }
} else { Ignore }
} );
    next if @stats.grep: * == Negative ;
    .say if @stats.grep: * == Positive ;
}
