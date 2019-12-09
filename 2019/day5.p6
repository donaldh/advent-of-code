#!/usr/bin/env perl6

use v6;

sub execute(@program is copy, @inputs is copy) {
    my $p = 0;
    my @results;

    sub pos(@program, $pos, $mode) { $mode == 1 ?? $pos !! @program[$pos] }

    loop {
        my ($third, $second, $first, $op) = ('%05s'.sprintf(@program[$p]) ~~ /(\d) (\d) (\d) (\d\d)/).map(+*);
#        say "$third, $second, $first, $op";
        given $op {
            when 1 { # add
                my $a-pos = pos(@program, $p + 1, $first);
                my $b-pos = pos(@program, $p + 2, $second);
                my $result-pos = pos(@program, $p + 3, $third);

                @program[$result-pos] = @program[$a-pos] + @program[$b-pos];
                $p += 4;
            }
            when 2 { # multiply
                my $a-pos = pos(@program, $p + 1, $first);
                my $b-pos = pos(@program, $p + 2, $second);
                my $result-pos = pos(@program, $p + 3, $third);

                @program[$result-pos] = @program[$a-pos] * @program[$b-pos];
                $p += 4;
            }
            when 3 { # input
                my $value = @inputs.shift;
                my $pos = pos(@program, $p + 1, $first);
                @program[$pos] = $value;
                $p += 2;
            }
            when 4 { # output
                my $pos = pos(@program, $p + 1, $first);
                @results.push: @program[$pos];
                $p += 2;
            }
            when 5 { # jump-if-true
                my $pos = pos(@program, $p + 1, $first);
                my $move-pos = pos(@program, $p + 2, $second);
                if @program[$pos] != 0 {
                    $p = @program[$move-pos]
                } else {
                    $p +=3;
                }
            }
            when 6 { # jump-if-false
                my $pos = pos(@program, $p + 1, $first);
                my $move-pos = pos(@program, $p + 2, $second);
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
                @program[$result-pos] = @program[$a-pos] < @program[$b-pos];
                $p += 4;
            }
            when 8 { # equals
                my $a-pos = pos(@program, $p + 1, $first);
                my $b-pos = pos(@program, $p + 2, $second);
                my $result-pos = pos(@program, $p + 3, $third);
                @program[$result-pos] = @program[$a-pos] == @program[$b-pos];
                $p += 4;
            }
            when 99 {
                return @results;
            }
            default {
                fail "Unexpected instruction $_";
            }
        }
    }

    @program;
}

my @program = slurp('5.txt').split(',');

say "Part 1";
execute(@program, (1,)).say;

say "Part 2";
execute(@program, (5,)).say;
