#!/usr/bin/env perl6
use v6;

my $input = 'uugsqrei';

constant LIST-SIZE = 256;

my $total = 0;

for 0..127 -> $row {
    my $binary = knot("{$input}-{$row}");

    $total += [+] $binary.comb;
}

say $total;

sub knot($text) {
    my @lengths = flat $text.encode.List, 17, 31, 73, 47, 23;
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

    my $knot = @dense.map({ sprintf('%08b', $_) }).join('').lc;
    say "{$knot}";
    $knot;
}
