#!/usr/bin/env perl6
use v6;

my $input = slurp '12.txt';

my %regs = 'a' => 0, 'b' => 0, 'c' => 1, 'd' => 0;
my @instructions = $input.lines;

say %regs;

my $pc = 0;

while $pc < +@instructions {

    given @instructions[$pc] {
        when / 'add ' (\w) ' ' (\w) / {
            say "add {$0} {$1}";
            %regs{~$1} += %regs{~$0};
            $pc += 1;
        }
        when / 'cpy ' (\d+) ' ' (\w) / {
            say "cpy + {+$0} -> @ {$1}";
            %regs{~$1} = +$0;
            $pc += 1;
        }
        when / 'cpy ' (\w) ' ' (\w) / {
            say "cpy @ {$0} -> @ {$1}";
            %regs{~$1} = %regs{~$0};
            $pc += 1;
        }
        when / 'jnz ' (\d) ' ' ('-'?\d+) / {
            say "jnz + {$0} -> ~ {+$1}";
            if +$0 != 0 {
                $pc += +$1;
            } else {
                $pc += 1;
            }
        }
        when / 'jnz ' (\w) ' ' ('-'?\d+) / {
            say "jnz @ {$0} -> ~ {+$1}";
            if %regs{~$0} != 0 {
                $pc += +$1;
            } else {
                $pc += 1;
            }
        }
        when / 'inc ' (\w) / {
            say "inc @ {$0}";
            %regs{~$0} += 1;
            $pc += 1;
        }
        when / 'dec ' (\w) / {
            say "dec @ {$0}";
            %regs{~$0} -= 1;
            $pc += 1;
        }
        default {
            die 'unrecognised instruction';
        }
    }
}

say "{$pc} - {%regs.gist}";
