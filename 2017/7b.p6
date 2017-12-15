#!/usr/bin/env perl6
use v6;

my $input = slurp '7.txt';

class Program {
    has $.name;
    has $.weight;
    has @.programs;
    has @.carrying;
    has $.sum;
}

my %programs;
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

        %programs{$name} = Program.new(:$name, :$weight, :@programs);
    }
}


for %programs.values -> $p {
    say "{$p.name} appears to be the bottom program" unless %on{$p.name};
    tower-weight($p) unless %on{$p.name};
}

sub tower-weight(Program $p) {
    $p.carrying = $p.programs.map: { $_ => tower-weight %programs{$_} }
    my @weights = $p.carrying.map: { .value };
    if [==] @weights {
        $p.sum = [+] @weights;
        return $p.sum + $p.weight;
    } else {
        say "{$p.name} {$p.programs} {@weights}";
        for $p.programs -> $n {
            my Program $p = %programs{$n};
            say "{$p.name} -- { $p.weight } + { $p.carry-sum }";
        }
        exit
    }
}
