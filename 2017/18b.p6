#!/usr/bin/env perl6
use v6;

my $input = '18.txt';

my @instructions = $input.IO.lines;

class Deadlock is Exception { }

class Program {
    has $.id;
    has $.in;
    has $.out;
    has %.registers;
    has $.pc;
    has $.sent;

    submethod BUILD(:$!id, :$!in, :$!out) {
        %!registers<p> = $!id;
        $!pc = 0;
        $!sent = 0;
        say self.perl;
    }

    method run {
        while $!pc < +@instructions {

            my $instr = "{$!pc}\t{@instructions[$!pc]}";

            given @instructions[$!pc] {
                when /^ 'set ' (\w+) ' ' ('-'? \d+) / {
                    %!registers{~$0} = +$1;
                    $!pc++;
                }
                when /^ 'set ' (\w+) ' ' (\w) / {
                    %!registers{~$0} = %!registers{~$1} // 0;
                    $!pc++;
                }
                when /^ 'add ' (\w+) ' ' ('-'? \d+) / {
                    my $lhs = %!registers{~$0} // 0;
                    %!registers{~$0} = $lhs + +$1;
                    $!pc++;
                }
                when /^ 'add ' (\w+) ' ' (\w) / {
                    my $lhs = %!registers{~$0} // 0;
                    my $rhs = %!registers{~$1} // 0;
                    %!registers{~$0} = $lhs + $rhs;
                    $!pc++;
                }
                when /^ 'mul ' (\w+) ' ' ('-'? \d+) / {
                    my $lhs = %!registers{~$0} // 0;
                    %!registers{~$0} = $lhs * +$1;
                    $!pc++;
                }
                when /^ 'mul ' (\w+) ' ' (\w) / {
                    my $lhs = %!registers{~$0} // 0;
                    my $rhs = %!registers{~$1} // 0;
                    %!registers{~$0} = $lhs * $rhs;
                    $!pc++;
                }
                when /^ 'mod ' (\w+) ' ' ('-'? \d+) / {
                    my $lhs = %!registers{~$0} // 0;
                    %!registers{~$0} = $lhs % +$1;
                    $!pc++;
                }
                when /^ 'mod ' (\w+) ' ' (\w) / {
                    my $lhs = %!registers{~$0} // 0;
                    my $rhs = %!registers{~$1} // 0;
                    %!registers{~$0} = $lhs % $rhs;
                    $!pc++;
                }
                when /^ 'snd ' (\w) / {
                    $!out.send: %!registers{~$0} // 0;
                    $!sent++;
                    $!pc++;
                }
                when /^ 'rcv ' (\w) / {
                    %!registers{~$0} = self.receive;
                    $!pc++;
                }
                when /^ 'jgz ' (\d+) ' ' ('-'? \d+) / {
                    if +$0 > 0 {
                        $!pc += +$1;
                    } else {
                        $!pc += 1;
                    }
                }
                when /^ 'jgz ' (\w) ' ' ('-'? \d+) / {
                    my $val = %!registers{~$0} // 0;
                    if $val > 0 {
                        $!pc += +$1;
                    } else {
                        $!pc += 1;
                    }
                }
                when /^ 'jgz ' (\w) ' ' (\w) / {
                    my $val = %!registers{~$0} // 0;
                    my $off = %!registers{~$1} // 0;
                    if $val > 0 {
                        $!pc += $off;
                    } else {
                        $!pc += 1;
                    }
                }
            }

            say "{$!id}: {$instr}\t{%!registers.gist}";
        }
    }

    method receive {
        for 1..3 -> $i {
            if $!in.poll -> $val {
                return $val;
            } else {
                sleep $i;
            }
        }
        Deadlock.new.throw;
    }
}

my $zero-to-one = Channel.new;
my $one-to-zero = Channel.new;

my $zero = Program.new(id => 0, in => $one-to-zero, out => $zero-to-one);
my $one = Program.new(id => 1, in => $zero-to-one, out => $one-to-zero);

await start { try { $zero.run } }, start { try { $one.run } };

for $zero, $one -> $p {
    say "Process {$p.id} sent values {$p.sent} times";
}
