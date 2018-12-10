#!/usr/bin/env perl6
use v6;

my @input = '8-input.txt'.IO.words;
my $sum-of-meta = 0;

sub node {
    my $num-children = @input.shift;
    my $num-metadata = @input.shift;

    my @child-values = (node for ^$num-children);
    my @meta-values = (@input.shift for ^$num-metadata);
    $sum-of-meta += [+] @meta-values;

    [+] ($num-children > 0) ?? (
        @meta-values.map(
            -> $index {
                $index == 0 || $index > +@child-values ?? 0 !! @child-values[$index - 1]
            }
        ))
    !! @meta-values;
}

my $root-value = node;
say "Part 1 sum={$sum-of-meta}. Part 2 value={$root-value}";
