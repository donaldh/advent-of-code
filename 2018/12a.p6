#!/usr/bin/env perl6
use v6;

my @input = '12-input.txt'.IO.lines;

my $initial-state = ~(@input.shift ~~ /<[#\.]>+/) ;
my %rules = @input.comb(/<[#\.]>+/);

say $initial-state;
say %rules;

my %state = (0..* Z $initial-state.comb).map({ .head => .tail });
say %state;

for 1..20 -> $iter {
    $iter.say if $iter %% 1000_000;
    my %new-state;

    for -5 ... %state.keys.max(*.Int) + 5 -> $c {

        my $pattern = (
            (%state{$c-2} // '.'),
            (%state{$c-1} // '.'),
            (%state{$c} // '.'),
            (%state{$c+1} // '.'),
            (%state{$c+2} // '.')
        ).join;

        my $value = %rules{$pattern} // '.';
        %new-state{$c} = $value if $value eq '#';
    }

    %state = %new-state;

    # for -5 ... %state.keys.max(*.Int) + 5 -> $c {
    #     print %state{$c} // '.';
    # }
    # say '';

    say "Iteration {$iter} -> { [+] %state.keys }";

}
