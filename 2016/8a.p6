#!/usr/bin/env perl6

my $input = slurp '8.txt';

my @display[50;6];

for $input.lines {

    when /'rect' \s+ (\d+) 'x' (\d+)/ {
        # say "rect {$0} x {$1}";
        for 0..^$0 -> $x {
            for 0..^$1 -> $y {
                @display[$x;$y] = True;
            }
        }
    }

    when /'rotate row y=' (\d+) \s+ 'by' \s+ (\d+)/ {
        # say "rotate y={$0} by {$1}";
        my $y = +$0;
        for 1..$1 {
            my $t = @display[49;$y];
            for (1..^50).reverse -> $x {
                @display[$x;$y] = @display[$x - 1;$y]
            }
            @display[0;$y] = $t;
        }
    }

    when /'rotate column x=' (\d+) \s+ 'by' \s+ (\d+)/ {
        # say "rotate x={$0} by {$1}";
        my $x = +$0;
        for 1..$1 {
            my $t = @display[$x;5];
            for (1..^6).reverse -> $y {
                @display[$x;$y] = @display[$x; $y -1];
            }
            @display[$x;0] = $t;
        }
    }
}

my $total-lit = 0;
for 0..^6 -> $y {
    for 0..^50 -> $x {
        my $lit = @display[$x;$y];
        print $lit ?? '◼︎' !! ' ';
        $total-lit++ if $lit;
    }
    say '';
}
say "There are {$total-lit} lit pixels";
