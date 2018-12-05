#!/usr/bin/env perl6
use v6;

my $str = '5a-input.txt'.IO.slurp.chomp;

my $length;
repeat {
    $length = $str.chars;
    $str .= trans(('a'..'z' Z~ 'A'..'Z') => '', ('A'..'Z' Z~ 'a'..'z') => '');
} while $str.chars < $length;

say $str;
say $str.chars;
