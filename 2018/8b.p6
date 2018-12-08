#!/usr/bin/env perl6
use v6;

my @input = '8-input.txt'.IO.words;

sub node {
    my $num-children = @input.shift;
    my $num-metadata = @input.shift;

    my @child-values = (node for ^$num-children);
    my @meta-values = (@input.shift for ^$num-metadata);

    [+] ($num-children > 0) ?? (
        @meta-values.map(
            -> $index {
                $index == 0 || $index > +@child-values ?? 0 !! @child-values[$index - 1]
            }
        ))
    !! @meta-values;
}

say node;
