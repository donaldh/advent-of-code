#!/usr/bin/env perl6
use v6;

my $input =
"4	1	15	12	0	9	9	5	5	8	7	3	14	5	12	3";

my @banks = $input.split: /\s+/;
my %seen;

for 1..* -> $iteration {

    my $index = @banks.pairs.sort({ $^b.value <=> $^a.value || $^a.key <=> $^b.key }).head.key;
    my $redistribute = @banks[$index];
    @banks[$index] = 0;

    for 1..$redistribute -> $n {
        @banks[($index + $n) % +@banks] += 1;
    }

    my $signature = @banks.join: ',';
    if %seen{$signature} {
        say "Bank configuration {$signature} seen after {$iteration} iterations";
        say "Cycle is {$iteration - %seen{$signature} } iterations long";
        exit;
    }

    %seen{$signature} = $iteration;
}
