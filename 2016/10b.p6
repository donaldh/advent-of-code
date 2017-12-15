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
        %actions{~$0} = { 'low' ~ $1 => ~$2, 'high' ~ $3 => ~$4 };
    }
}

my @work;

for %bots.kv -> $k, @values {
    if +@values == 2 {
        @work.push: $k;
        last;
    }
}

while +@work > 0 {
    my $k = @work.shift;

    my ($low, $high) = %bots{$k}.sort(&infix:«<=>»);
    %bots{$k} = ();
    my %ops = %actions{$k};

    bot(%ops<lowbot>, $low);
    output(%ops<lowoutput>, $low);
    bot(%ops<highbot>, $high);
    output(%ops<highoutput>, $high);
}

sub bot($id, Int $value) {
    if $id {
        %bots{$id}.push: $value;
        @work.push: $id if +%bots{$id} == 2;
    }
}

sub output($id, Int $value) {
    if $id {
        %outputs{~$id} = $value;
    }
}

say "Result is {%outputs<0> * %outputs<1> * %outputs<2>}";

