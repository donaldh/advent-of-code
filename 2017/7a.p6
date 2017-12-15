#!/usr/bin/env perl6
use v6;

my $input = slurp '7.txt';

my %supporting;
my %on;

for $input.lines {
    if /^ (\w+) ' (' (\d+) ')' / {
        my $name = $0;
        my $weight = $1;
        my @programs;

        if / ' -> ' (.*) / {
            @programs = $0.split: ', ';
            for @programs -> $p {
                %on{$p} = $name;
            }
        }
        %supporting{$name} = 'weight' => $weight, 'programs' => @programs;
    }
}


for %supporting.keys -> $s {
    say "{$s} appears to be the bottom program" unless %on{$s};
}
