#!/usr/bin/env perl6

use v6;

my @box-ids = '2a-input.txt'.IO.lines;
my $twos = 0;
my $threes = 0;

for @box-ids {
    my %bag = .comb.Bag.antipairs;
    $twos += 1 if %bag<2>;
    $threes += 1 if %bag<3>;
}

say "Checksum is {$twos * $threes}";

for @box-ids.combinations: 2 -> [$a, $b] {
    my $diffs = 0;
    my @chars = gather {
        for $a.comb Z $b.comb -> [$ac, $bc] {
            if $ac eq $bc {
                take $ac;
            } else {
                $diffs += 1;
            }
        }
    }
    if $diffs == 1 {
        say $a;
        say $b;
        say '---';
        say @chars.join;
    }
}
