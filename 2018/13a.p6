#!/usr/bin/env perl6
use v6;
use NCurses;

my $win = initscr;
die "Failed to initialize ncurses" unless $win.defined;

my @grid[;] = '13-input.txt'.IO.lines>>.comb;

enum Dir <North East South West>;
enum Turn <Left Straight Right>;
my %dir-chars = North => '^', East => '>', South => 'v', West => '<';        # bogus '>'

class Cart {
    has Dir $.dir; has $.x is rw; has $.y is rw; has Turn $.turn is rw = Left;
    method move {
        mvaddstr $!y, $!x, @grid[$!y;$!x];
        given $!dir {
            when North {
                $!y -= 1;
                given @grid[$!y;$!x] {
                    when '|' | '^' | 'v' { }
                    when '\\' { $!dir = West; }
                    when '/' { $!dir = East; }
                    when '+' {
                        given $!turn { when Left { $!dir = West; }; when Right { $!dir = East; } }
                        $!turn = Turn(($!turn + 1) % 3);
                    }
                }
            }
            when East {
                $!x += 1;
                given @grid[$!y;$!x] {
                    when '-' | '<' | '>' { }
                    when '\\' { $!dir = South; }
                    when '/' { $!dir = North; }
                    when '+' {
                        given $!turn { when Left { $!dir = North; }; when Right { $!dir = South; } }
                        $!turn = Turn(($!turn + 1) % 3);
                    }
                }
            }
            when South {
                $!y += 1;
                given @grid[$!y;$!x] {
                    when '|' | '^' | 'v' {
                    }
                    when '\\' { $!dir = East; }
                    when '/' { $!dir = West; }
                    when '+' {
                        given $!turn { when Left { $!dir = East; }; when Right { $!dir = West; } }
                        $!turn = Turn(($!turn + 1) % 3);
                    }
                }
            }
            when West {
                $!x -= 1;
                given @grid[$!y;$!x] {
                    when '-' | '<' | '>' {
                    }
                    when '\\' { $!dir = North; }
                    when '/' { $!dir = South; }
                    when '+' {
                        given $!turn { when Left { $!dir = South; }; when Right { $!dir = North; } }
                        $!turn = Turn(($!turn + 1) % 3);
                    }
                }
            }
        }
        mvaddstr $!y, $!x, %dir-chars{$!dir};
        nc_refresh;
    }
}

# Cart-scan
my @carts = gather {
    for 0..^150 -> $y {
        for 0..^150 -> $x {
            given @grid[$y;$x] {
                when '^' {
                    take Cart.new(dir => North, :$x, :$y);
                    #@grid[$y;$x] = '|';
                }
                when '>' {
                    take Cart.new(dir => East, :$x, :$y);
                    #@grid[$y;$x] = '-';
                }
                when 'v' {
                    take Cart.new(dir => South, :$x, :$y);
                    #@grid[$y;$x] = '|';
                }
                when '<' {                                     # bogus '>'
                    take Cart.new(dir => West, :$x, :$y);
                    #@grid[$y;$x] = '-';
                }
                default { }
            }
        }
    }
}

sub draw {
    for 0..^150 -> $y {
        for 0..^150 -> $x {
            printw @grid[$y;$x];
        }
        printw "\n";
    }
    nc_refresh;
}

draw;

loop {
    for @carts.sort({ .y, .x }) -> $c {
        $c.move;
        my @candidates = @carts.grep({ .x == $c.x && .y == $c.y });
        if +@candidates == 2 {
            mvaddstr 75, 70, " *** {$c.x},{$c.y} *** ";
            nc_refresh;
            while getch() < 0 { };
            endwin;
            exit;
        }
    }
}
