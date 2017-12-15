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

my $total-groups = 0;

while %pipes {
    my $start = %pipes.keys.head;
    my SetHash $seen = SetHash.new;

    visit($start);
    $total-groups++;

    sub visit($which) {
        $seen{$which} = True;
        for %pipes{$which}.keys -> $n {
            unless $seen{$n} {
                visit($n);
            }
        }
        %pipes{$which}:delete;
    }
}

say "There are {$total-groups} process groups";
