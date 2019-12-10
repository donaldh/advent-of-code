#!/usr/bin/env perl6

use v6;
constant debug = False;

sub execute($id, @input-program, Channel $in, Channel $out) {

    my @program is default(0) = @input-program;

    my $relative-base = 0;
    my $p = 0;

    sub pos(@program, $pos, $mode) {
        given $mode {
            when 0 { @program[$pos] }
            when 1 { $pos }
            when 2 { $relative-base + @program[$pos] }
        }
    }

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
            when 9 { # adjust relative base
                my $pos = pos(@program, $p + 1, $first);
                $relative-base += @program[$pos];
                say "$id: adj $pos -- relative-base now {$relative-base}" if debug;
                $p += 2;
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

sub test($test-program) {
    my @program = $test-program.split(',');
    my $in = Channel.new;
    my $out = Channel.new;
    execute(1, @program, $in, $out);
    $in.close; $out.close;
    say $out.list;
}

test('109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99');
test('1102,34915192,34915192,7,4,7,99,0');
test('104,1125899906842624,99');

my @program = slurp('9.txt').split(',');

sub boost($param) {
    my $in = Channel.new;
    my $out = Channel.new;

    $in.send($param);
    execute($param, @program, $in, $out);

    $in.close; $out.close;
    say $out.list;
}

say "Part 1";
boost(1);

say "Part 2";
boost(2);
