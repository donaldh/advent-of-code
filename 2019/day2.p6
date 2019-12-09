#!/usr/bin/env perl6

use v6;
use Test;

multi sub run(Str $input) {
    run $input.split(',')
}

multi sub run(@program is copy) {
    my $p = 0;

    loop {
        given @program[$p] {
            when 1 {
                my $a-pos = @program[$p + 1];
                my $b-pos = @program[$p + 2];
                my $result-pos = @program[$p + 3];

                @program[$result-pos] = @program[$a-pos] + @program[$b-pos];
            }
            when 2 {
                my $a-pos = @program[$p + 1];
                my $b-pos = @program[$p + 2];
                my $result-pos = @program[$p + 3];

                @program[$result-pos] = @program[$a-pos] * @program[$b-pos];
            }
            when 99 {
                return @program;
            }
            default {
                fail "Unexpected instruction $_";
            }
        }
        $p += 4;
    }

    @program;
}

is run('1,0,0,0,99'), <2 0 0 0 99>;
is run('2,3,0,3,99'), <2 3 0 6 99>;
is run('2,4,4,5,99,0'), <2 4 4 5 99 9801>;
is run('1,1,1,4,99,5,6,0,99'), <30 1 1 4 2 5 6 0 99>;

my @program = slurp('2.txt').split(',');
@program[1,2] = 12, 2;

say "Part 1 - { run(@program)[0] }";

for 0..99 -> $noun {
    for 0..99 -> $verb {
        @program[1,2] = $noun, $verb;

        if run(@program)[0] == '19690720' {
            say "Part 2 - { 100 * $noun + $verb }";
            exit;
        }
    }
}
