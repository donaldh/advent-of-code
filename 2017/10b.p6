#!/usr/bin/env perl6
use v6;

my $input = '199,0,255,136,174,254,227,16,51,85,1,2,22,17,7,192';
my @lengths = flat $input.encode.List, 17, 31, 73, 47, 23;

constant LIST-SIZE = 256;
my @numbers[LIST-SIZE] = 0..^LIST-SIZE;

my $pos = 0;
my $skip = 0;

for 1..64 {
    for @lengths -> $length {

        @numbers[0..^$length] .= reverse;
        @numbers .= rotate($length + $skip);

        $pos -= $length + $skip;
        $pos %= LIST-SIZE;

        $skip += 1;
    }
}

@numbers .= rotate($pos);

my @dense = (0..15).map({$_ * 16}).map: {
    [+^] @numbers[$_..^($_ + 16)]
};

say @dense.map(*.base(16)).join('').lc;
