#!/usr/bin/env perl6
use v6;

my %rules = '21.txt'.IO.lines.map: {
    /(<[#./]>+) ' => ' (<[#./]>+)/;
    ~$0 => ~$1
};

my $start = '.#./..#/###';

my @working[;] = grid($start);

sub grid($str) {
    my @arr[;] = $str.split('/').map({ .comb.Array });
    @arr
}

sub diagonal($in) {
    $in.comb.reverse.join('')
}

sub mirror($in) {
    $in.split('/').reverse.join('/')
}

sub show($in) {
    say $in.split('/').join("\n");
    say "\n";
}

sub apply(@from, $many) {
    my $n = join('/', (0..^$many).map( -> $i { @from[$i; 0..^$many].join('') }));
    my $nm = mirror $n;
    my $e = join('/', (0..^$many).reverse.map( -> $i { @from[0..^$many; $i].join('') }));
    my $em = mirror $e;
    my $s = diagonal $n;
    my $sm = mirror $s;
    my $w = diagonal $e;
    my $wm = mirror $w;

    my @in = $n, $nm, $e, $em, $s, $sm, $w, $wm;
    %rules{@in}:v.head;
}

sub split($from) {
    given $from {
        when / [(..)(..)] ** 4 % '/' / {
            my @corners = ($/[0][0].Str, $/[0][1].Str), ($/[1][0].Str, $/[1][1].Str),
            ($/[0][2].Str, $/[0][3].Str), ($/[1][2].Str, $/[1][3].Str);
            @corners.map( { .join('/') } )
        }

        when / [(...)(...)] ** 6 % '/' / {
        }

        default {
            $from
        }
    }
}


say apply(@working, 3);
show apply(@working, 3);


for split(apply(@working, 3)) {
    my $three = apply(grid($_), 2);
    say $three;
    say apply(grid($three), 3)
}
