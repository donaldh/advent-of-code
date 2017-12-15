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

        method group($/) { make join('', $<group>.map(*.made), $<garbage>.map(*.made)) }

        method garbage($/) { make join('', $<garbage-char>) }

        method garbage-char($/) { make ~$/; }
    }

    method parse(|c) { nextwith(actions => Actions, |c); }

    method FAILGOAL (|c) { say c }
}

my $garbage = Day9.parse(slurp '9.txt').made;

say "There are {$garbage.chars} non-cancelled characters of garbage";
