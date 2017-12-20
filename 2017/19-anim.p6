#!/usr/bin/env perl6
use v6;

use Terminal::Print;

my $screen = Terminal::Print.new;
$screen.initialize-screen;

my @grid[;] = '19.txt'.IO.lines>>.comb;

sub draw {
    for 0..^200 -> $y {
        for 0..200 -> $x {
            $screen.print-cell: $x, $y, {char =>@grid[$y;$x], color => 'bold yellow'};
        }
        say '';
    }
}

draw;

enum <North East South West>;

my $x;
my $y = 0;
my $dir = South;
my @chars;
my $steps = 0;

for 0..200 -> $i {
    if @grid[$y;$i] ~~ '|' {
        $x = $i;
        last;
    }
}

sub forward {
    given $dir {
        when North {
            $y -= 1;
        }
        when South {
            $y += 1;
        }
        when West {
            $x -= 1;
        }
        when East {
            $x += 1;
        }
    }
    $steps += 1;
}

sub turn {
    given $dir {
        when North {
            if @grid[$y;$x-1] ~~ /<[-|]>/ {
                $dir = West;
            } else {
                $dir = East;
            }
        }
        when East {
            if @grid[$y-1;$x] ~~ /<[-|]>/ {
                $dir = North;
            } else {
                $dir = South;
            }
        }
        when South {
            if @grid[$y;$x+1] ~~ /<[-|]>/ {
                $dir = East;
            } else {
                $dir = West;
            }
        }
        when West {
            if @grid[$y+1;$x] ~~ /<[-|]>/ {
                $dir = South;
            } else {
                $dir = North;
            }
        }
    }
}


loop {
    $screen.print-cell: $x, $y, @grid[$y;$x];

    given @grid[$y;$x] {
        when /<[-|]>/ {
            forward;
        }
        when '+' {
            turn;
            forward;
        }
        when /<[A..Z]>/ {
            @chars.push: @grid[$y;$x];
            forward;
        }
        default {
            sleep 2;
            $screen.shutdown-screen;
            say @chars.join('');
            say "Taken {$steps} steps";
            exit;
        }
    }
}

