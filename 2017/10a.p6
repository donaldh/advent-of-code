#!/usr/bin/env perl6
use v6;

my $input = '199,0,255,136,174,254,227,16,51,85,1,2,22,17,7,192';

constant LIST-SIZE = 256;
my @numbers[LIST-SIZE] = 0..^LIST-SIZE;

my $pos = 0;
my $skip = 0;

for $input.split(',') -> $length {
    say "pos: {$pos}, length: {$length}";

    @numbers[0..^$length] .= reverse;
    @numbers .= rotate($length + $skip);

    $pos -= $length + $skip;
    $pos %= LIST-SIZE;

    #say @numbers.rotate($pos);

    $skip += 1;
}

@numbers .= rotate($pos);

say @numbers[0] * @numbers[1];
