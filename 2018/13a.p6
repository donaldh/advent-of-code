#!/usr/bin/env perl6
use v6;

my @grid[;] = '13-input.txt'.IO.lines>>.comb;

enum <North East South West>;
enum <Left Straight Right>;

class Cart {
    has $.dir; has $.x is rw; has $.y is rw; has $.turn is rw = Left;
    method move {
        given $!dir {
            when North {
                given @grid[$!y;$!x-1] {
                    when '|' {
                        $!x -= 1;
                    }
                    when '\\' {
                        $!x -= 1;
                        $!dir = West;
                    }
                    when '/' {
                        $!x -= 1;
                        $!dir = East;
                    }
                    when '+' {
                    }
                }
            }
            when East {
            }
            when South {
            }
            when West {
            }
        }
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
            print @grid[$y;$x];
        }
        say '';
    }
}

draw;
exit;

loop {
    for @carts.sort({ .y, .x }) -> $c {
        move $c;
    }
}

