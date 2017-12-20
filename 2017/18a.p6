#!/usr/bin/env perl6
use v6;

my $input = '18.txt';

my @instructions = $input.IO.lines;
my %registers;
my $sound;

my $pc = 0;

while $pc < +@instructions {

    my $instr = "{$pc}\t{@instructions[$pc]}";

    given @instructions[$pc] {
        when /^ 'set ' (\w+) ' ' ('-'? \d+) / {
            %registers{~$0} = +$1;
            $pc++;
        }
        when /^ 'set ' (\w+) ' ' (\w) / {
            %registers{~$0} = %registers{~$1} // 0;
            $pc++;
        }
        when /^ 'add ' (\w+) ' ' ('-'? \d+) / {
            my $lhs = %registers{~$0} // 0;
            %registers{~$0} = $lhs + +$1;
            $pc++;
        }
        when /^ 'add ' (\w+) ' ' (\w) / {
            my $lhs = %registers{~$0} // 0;
            my $rhs = %registers{~$1} // 0;
            %registers{~$0} = $lhs + $rhs;
            $pc++;
        }
        when /^ 'mul ' (\w+) ' ' ('-'? \d+) / {
            my $lhs = %registers{~$0} // 0;
            %registers{~$0} = $lhs * +$1;
            $pc++;
        }
        when /^ 'mul ' (\w+) ' ' (\w) / {
            my $lhs = %registers{~$0} // 0;
            my $rhs = %registers{~$1} // 0;
            %registers{~$0} = $lhs * $rhs;
            $pc++;
        }
        when /^ 'mod ' (\w+) ' ' ('-'? \d+) / {
            my $lhs = %registers{~$0} // 0;
            %registers{~$0} = $lhs % +$1;
            $pc++;
        }
        when /^ 'mod ' (\w+) ' ' (\w) / {
            my $lhs = %registers{~$0} // 0;
            my $rhs = %registers{~$1} // 0;
            %registers{~$0} = $lhs % $rhs;
            $pc++;
        }
        when /^ 'snd ' (\w) / {
            $sound = %registers{~$0} // 0;
            $pc++;
        }
        when /^ 'rcv ' (\w) / {
            if %registers{~$0} // 0 != 0 {
                say $sound;
                exit;
            }
        }
        when /^ 'jgz ' (\d+) ' ' ('-'? \d+) / {
            if +$0 > 0 {
                $pc += +$1;
            } else {
                $pc += 1;
            }
        }
        when /^ 'jgz ' (\w) ' ' ('-'? \d+) / {
            my $val = %registers{~$0} // 0;
            if $val > 0 {
                $pc += +$1;
            } else {
                $pc += 1;
            }
        }
        when /^ 'jgz ' (\w) ' ' (\w) / {
            my $val = %registers{~$0} // 0;
            my $off = %registers{~$1} // 0;
            if $val > 0 {
                $pc += $off;
            } else {
                $pc += 1;
            }
        }
    }

    say "{$instr}\t{%registers.gist}";
}
