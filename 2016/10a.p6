#!/usr/bin/env perl6
use v6;

my $input = slurp '10.txt';

my %bots;
my %actions;
my %outputs;

for $input.lines {
    if / ^ 'value ' (\d+) ' goes to bot ' (\d+) / {
        %bots{~$1}.push(+$0);
    }
    if / ^ 'bot ' (\d+) ' gives low to ' ('bot'|'output') ' ' (\d+) ' and high to ' ('bot'|'output') ' ' (\d+) / {
        %actions{~$0} = { 'low' ~ $1 => +$2, 'high' ~ $3 => +$4 };
        say "{$0} low {$1} -> {$2}, high {$3} -> {$4}" if $1 ~~ 'output' or $3 ~~ 'output';
    }
}

for %actions.kv -> $k, %ops {
    next unless %bots{$k};
    my @values = %bots{$k}.sort;
    say @values;
    if +@values == 2 {
        if @values[0] == 17 and @values[1] == 61 {
            END { say "Bot {$k} has {@values}"; }
        }

        %bots{%ops<lowbot>}.push: @values[0] if %ops<lowbot>;
        %bots{%ops<highbot>}.push: @values[1] if %ops<highbot>;
        %outputs{%ops<lowoutput>}.push: @values[0] if %ops<lowoutput>;
        %outputs{%ops<highoutput>}.push: @values[1] if %ops<highoutput>;

        #%actions{$k}:delete;
    }
}

say %bots;
say %outputs;
