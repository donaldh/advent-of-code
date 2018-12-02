#!/usr/bin/env perl6

use v6;

my @values = '1a-input.txt'.IO.lines;
my $total = 0;
my %seen;

loop {
    for @values {
        $total += $_;
        if %seen{$total} {
            say $total;
            exit;
        }
        %seen{$total} = True;
    }
}
