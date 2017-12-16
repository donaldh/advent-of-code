#!/usr/bin/env perl6
use v6;

my $input = slurp '16.txt';

my @programs = 'a'..'p';

for $input.split(',') {
    when /'s' (\d+)/ {
        @programs .= rotate(- $0);
    }
    when /'x' (\d+) '/' (\d+) / {
        my $a = @programs[$0];
        my $b = @programs[$1];
        @programs[$0] = $b;
        @programs[$1] = $a;
    }
    when /'p' (\w) '/' (\w) / {
        my ($apos, $a) = @programs.first: * eq ~$0, :kv;
        my ($bpos, $b) = @programs.first: * eq ~$1, :kv;
        @programs[$apos] = $b;
        @programs[$bpos] = $a;
    }
}

say @programs.join('');
