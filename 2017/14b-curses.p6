#!/usr/bin/env perl6
use v6;

use NCurses;

my $win = initscr;
die "Failed to initialize ncurses" unless $win.defined;

my $input = slurp '14b.txt';
my $used = '.';
my $free = ' ';

my @disk[128;128] = $input.lines.map: *.chomp.comb.map: { $_ ~~ '1' ?? $used !! $free };

show;

my $groups = 0;

for 0..127 -> $y {
    for 0..127 -> $x {
        if @disk[$y;$x] ~~ $used {
            $groups++;
            flood $x, $y, "{$groups % 10}";
        }
    }
}

#show;
#say "There are {$groups} groups";

sub flood($x, $y, $char = ' ') {
    unless 0 <= $x < 128 { return }
    unless 0 <= $y < 128 { return }
    unless @disk[$y;$x] ~~ $used { return }

    @disk[$y;$x] = $char;
    mvaddstr $y, $x, "{$char}";
    nc_refresh;
    sleep 0.001;

    flood($x - 1, $y, $char);
    flood($x + 1, $y, $char);
    flood($x, $y - 1, $char);
    flood($x, $y + 1, $char);
}

sub show {
    for 0..127 -> $y {
        printw "{ (0..127).map({ @disk[$y;$_] }).join('') }\n";
    }
}

while getch() < 0 { };
endwin;
