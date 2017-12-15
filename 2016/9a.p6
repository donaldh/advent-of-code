#!/usr/bin/env perl6
use v6;

my $input = slurp '9.txt';

for $input.lines {

    my $line = $_;
    my $output = '';

    while $line.chars > 0 {
        given $line {
            when /^(<-[\(]>+)/ {
                $output ~= ~$0;
                $line .= substr($0.chars);
            }
            when /^ '(' (\d+) 'x' (\d+) ')' / {
                my $len = 3 + $0.chars + $1.chars;
                my $many = +$0;
                my $repeat = +$1;

                $line .= substr($len);
                my $part = $line.substr(0, $many);
                $line .= substr($many);

                $output ~= $part x $repeat;
            }
        }
    }

    say $output;
    say $output.chars;
}
