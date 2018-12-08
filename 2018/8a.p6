#!/usr/bin/env perl6
use v6;

my @input = '8-input.txt'.IO.words;
my $sum-of-metadata = 0;

sub node {
    my $children = @input.shift;
    my $metadata = @input.shift;
#    say "{$children} - {$metadata}";
    node for ^$children;
    $sum-of-metadata += @input.shift for ^$metadata;
}

node;

say $sum-of-metadata;
