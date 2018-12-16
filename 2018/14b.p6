#!/usr/bin/env perl6
use v6;

my Int @input = '110201'.comb>>.Int;
my Int @recipes = 3, 7;

my Int $elf1 = 0;
my Int $elf2 = 1;

loop {
    my Int @new-recipes = @recipes[$elf1,$elf2].sum.comb>>.Int;
    @recipes.append: @new-recipes;

    my $elf1-value = @recipes[$elf1];
    $elf1 = ($elf1 + $elf1-value + 1) % +@recipes;

    my $elf2-value = @recipes[$elf2];
    $elf2 = ($elf2 + $elf2-value + 1) % +@recipes;

    if @recipes[*-6 .. *] ~~ @input {
        say +@recipes - 6;
        exit;
    } elsif @recipes[*-7 ..^ *] ~~ @input {
        say +@recipes - 7;
        exit;
    }
    say +@recipes if +@recipes %% 10_000;
}
