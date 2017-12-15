#!/usr/bin/env perl6
use v6;

my $input = '12.txt';

my %pipes;

for $input.IO.lines {
    if /^ (\d+) ' <-> ' (.*) $/ {
        %pipes{$0} = $1.split(', ').Set;
    }
}

for %pipes.kv -> $k, $v {
    for $v.keys -> $program {
        %pipes{$program} = %pipes{$program} (|) $k;
    }
}

my SetHash $seen = SetHash.new: '0';

sub visit($which) {
    for %pipes{$which}.keys -> $n {
        unless $seen{$n} {
            $seen{$n} = True;
            visit($n);
        }
    }
}

visit('0');

say "Group containing program 0 has {+$seen} members";
