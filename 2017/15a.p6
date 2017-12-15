#!/usr/bin/env perl6
use v6;

my $a = 634;
my $b = 301;
my $a-factor = 16807;
my $b-factor = 48271;
my $divisor = 2147483647;

my $matches = 0;

for 1..40_000_000 {
    $a = ($a * $a-factor) % $divisor;
    $b = ($b * $b-factor) % $divisor;

    $matches += 1 if ($a +& 0xffff) == ($b +& 0xffff);
}

say "There were {$matches} matches";
