#!/usr/bin/env perl6
use v6;

my $a = 634;
my $b = 301;
my $matches = 0;

for 1..5_000_000 -> $i {
    ($a, $b) = await
         start { generate($a, 16807, 4) },
         start { generate($b, 48271, 8) };

    if ($a +& 0xffff) == ($b +& 0xffff) {
        $matches += 1;
        say "{$matches} at iteration {$i}";
    }
}

sub generate($previous, $factor, $mask) {
    my $result = $previous;
    repeat {
        $result = ($result * $factor) % 2147483647;
    } until $result %% $mask;

    $result
}

say "There were {$matches} matches";
my $duration = now - BEGIN { now }
say "Took {$duration} seconds";
