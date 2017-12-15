#!/usr/bin/env perl6
use v6;

my %registers;

my %infix =
'==' => &infix:<==>,
'!=' => &infix:<!=>,
'<' => &infix:<\<>,
'<=' => &infix:<\<=>,
'>' => &infix:<\>>,
'>=' => &infix:<\>=>;

my $max-seen = 0;

for '8.txt'.IO.lines {

    if /^ (\w+) \s+ ('inc' | 'dec') \s+ ('-'? \d+) \s+
    'if' \s+ (\w+) \s+ ('==' | '!=' | '<' | '<=' | '>' | '>=') \s+ ('-'? \d+) / {

        my $reg = ~$0;
        my $op = ~$1;
        my $value = +$2;

        my $test-reg = ~$3;
        my $test-cond = ~$4;
        my $test-value = +$5;

        %registers{$reg} = 0 unless %registers{$reg};
        %registers{$test-reg} = 0 unless %registers{$test-reg};

        my &test = %infix{$test-cond};

        if test(%registers{$test-reg}, $test-value) {
            given $op {
                when 'inc' {
                    %registers{$reg} += $value;
                }
                when 'dec' {
                    %registers{$reg} -= $value;
                }
            }
        }

        $max-seen = max($max-seen, %registers{$reg});

    } else {
        die;
    }
}

say %registers;
say "Highest value in any register is {max(%registers.values)}";
say "Max seen during execution is {$max-seen}";

