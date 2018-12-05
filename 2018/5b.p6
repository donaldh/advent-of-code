#!/usr/bin/env perl6
use v6;

my $str = '5a-input.txt'.IO.slurp.trim;

my @candidates = gather {
    for 'a' .. 'z' -> $c {
        my $work = $str.trans($c => '', $c.uc => '');
        my $length;
        repeat {
            $length = $work.chars;
            $work .= trans(('a'..'z' Z~ 'A'..'Z') => '', ('A'..'Z' Z~ 'a'..'z') => '');
        } while $work.chars < $length;
        take $work.chars;
    }
}

say @candidates.min;
