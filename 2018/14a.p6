#!/usr/bin/env perl6
use v6;

my $input = 110201;
my @recipes = 3, 7;
my @elfpos = 0, 1;

while +@recipes < $input + 10 {
    my @new-recipes = @recipes[@elfpos].sum.comb;
    @recipes.append: @new-recipes;

    for 0..1 -> $cur-elf {
        my $elf-pos = @elfpos[$cur-elf];
        my $recipe-value = @recipes[$elf-pos];
        @elfpos[$cur-elf] = ($elf-pos + $recipe-value + 1) % +@recipes;
    }
}

say @recipes[$input ..^ $input + 10].join;
