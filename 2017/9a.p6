#!/usr/bin/env perl6
use v6;

grammar Day9 {

    my $depth = 1;

    token TOP { ^ <group> \s* $ }

    token group { '{' ~ '}' [ <group> | <garbage> ]* % ',' }

    token garbage { '<' [ <garbage-char> | [ '!' . ] ]* '>' }

    token garbage-char { <-[ ! > ]> }

    class Actions {
        method TOP($/) { make $<group>.made }

        method group($/) { make $<group>.map(*.made) }
    }

    method parse(|c) { nextwith(actions => Actions, |c); }

    method FAILGOAL (|c) { say c }
}

my $groups = Day9.parse(slurp '9.txt').made;

sub accumulate($seq, $depth = 1) {
    if $seq {
        $depth, $seq.map: { accumulate($_, $depth + 1) }
    }
    else {
        $depth
    }
}

my $total = [+] flat accumulate($groups);
