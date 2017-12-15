#!/usr/bin/env perl6
use v6;

my @floors[5] =
Hash.new,
Hash(bag('po-g', 'th-g', 'th-m', 'pr-g', 'ru-g', 'ru-m', 'co-g', 'co-m')),
Hash(bag('po-m', 'pr-m')),
Hash.new,
Hash.new;

my $current = 1;

show;

move(2, 'po-g', 'pr-g');
move(4, 'po-g', 'po-m');
move(2, 'po-g');
move(4, 'po-g', 'pr-g');
move(1, 'pr-g');
move(4, 'pr-g', 'pr-m');
move(1, 'po-g');
move(2, 'co-g', 'co-m');
move(1, 'co-g');

sub sub-move(Int $to, $a) {
    @floors[$current]{$a} or die "No {$a} on floor {$current}";
    @floors[$current]{$a}:delete;
    @floors[$to]{$a} = 1;
}

multi sub move(Int $to, $a) {
    sub-move($to, $a);
    $current = $to;
    show;
}

multi sub move(Int $to, $a, $b) {
    sub-move($to, $a);
    sub-move($to, $b);
    $current = $to;
    show;
}

sub show() {
    for (1..4).reverse -> $f {
        say "F{$f}\t{@floors[$f].keys.sort.join("\t")}";
    }
    say '';
}
