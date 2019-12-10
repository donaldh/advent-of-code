#!/usr/bin/env perl6

use v6;
constant debug = False;

sub execute($id, @program is copy, Channel $in, Channel $out) {

    sub pos(@program, $pos, $mode) { $mode == 1 ?? $pos !! @program[$pos] }

    my $p = 0;

    loop {
        my @digits = @program[$p].comb;
        my $op = (@digits[*-2] // 0) * 10 + @digits[*-1];
        my $first = @digits[*-3] // 0;
        my $second = @digits[*-4] // 0;
        my $third = @digits[*-5] // 0;
        given $op {
            when 1 { # add
                my $a-pos = pos(@program, $p + 1, $first);
                my $b-pos = pos(@program, $p + 2, $second);
                my $result-pos = pos(@program, $p + 3, $third);

                say "$id: add $a-pos $b-pos -> $result-pos" if debug;
                @program[$result-pos] = @program[$a-pos] + @program[$b-pos];
                $p += 4;
            }
            when 2 { # multiply
                my $a-pos = pos(@program, $p + 1, $first);
                my $b-pos = pos(@program, $p + 2, $second);
                my $result-pos = pos(@program, $p + 3, $third);

                say "$id: mul $a-pos $b-pos -> $result-pos" if debug;
                @program[$result-pos] = @program[$a-pos] * @program[$b-pos];
                $p += 4;
            }
            when 3 { # input
                say "$id: inp" if debug;
                my $value = $in.receive;
                my $pos = pos(@program, $p + 1, $first);

                say "$id: \t$value -> $pos" if debug;
                @program[$pos] = $value;
                $p += 2;
            }
            when 4 { # output
                my $pos = pos(@program, $p + 1, $first);
                say "$id: out $pos" if debug;
                $out.send: @program[$pos];
                $p += 2;
            }
            when 5 { # jump-if-true
                my $pos = pos(@program, $p + 1, $first);
                my $move-pos = pos(@program, $p + 2, $second);
                say "$id: jt $pos $move-pos" if debug;
                if @program[$pos] != 0 {
                    $p = @program[$move-pos]
                } else {
                    $p +=3;
                }
            }
            when 6 { # jump-if-false
                my $pos = pos(@program, $p + 1, $first);
                my $move-pos = pos(@program, $p + 2, $second);
                say "$id: jf $pos $move-pos" if debug;
                if @program[$pos] == 0 {
                    $p = @program[$move-pos]
                } else {
                    $p += 3;
                }
            }
            when 7 { # less than
                my $a-pos = pos(@program, $p + 1, $first);
                my $b-pos = pos(@program, $p + 2, $second);
                my $result-pos = pos(@program, $p + 3, $third);
                say "$id: lt $a-pos $b-pos -> $result-pos" if debug;
                @program[$result-pos] = @program[$a-pos] < @program[$b-pos];
                $p += 4;
            }
            when 8 { # equals
                my $a-pos = pos(@program, $p + 1, $first);
                my $b-pos = pos(@program, $p + 2, $second);
                my $result-pos = pos(@program, $p + 3, $third);
                say "$id: eq $a-pos $b-pos -> $result-pos" if debug;
                @program[$result-pos] = @program[$a-pos] == @program[$b-pos];
                $p += 4;
            }
            when 99 {
                say "$id: exit" if debug;
                return;
            }
            default {
                fail "Unexpected instruction $_";
            }
        }
    }
}

my @program = slurp('7.txt').split(',');

say "Part 2";

my @signals = gather {
    for (5..9).permutations -> @phases {
        my $first = Channel.new; $first.send(@phases[0]); $first.send(0);
        my $second = Channel.new; $second.send(@phases[1]);
        my $third = Channel.new; $third.send(@phases[2]);
        my $fourth = Channel.new; $fourth.send(@phases[3]);
        my $fifth = Channel.new; $fifth.send(@phases[4]);
        await(
            start {
                execute(1, @program, $first, $second);
            },
            start {
                execute(2, @program, $second, $third);
            },
            start {
                execute(3, @program, $third, $fourth);
            },
            start {
                execute(4, @program, $fourth, $fifth);
            },
            start {
                execute(5, @program, $fifth, $first);
            }
        );

        take $first.receive;
    }
}

say @signals.max;

