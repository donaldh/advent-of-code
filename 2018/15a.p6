#!/usr/bin/env perl6
use v6;
use NCurses;

enum Type <Elf Goblin>;
class Unit { ... };

my @grid[32;32] = '15-input.txt'.IO.lines>>.comb;

my @units = gather {
    for 0..^32 -> $y {
        for 0..^32 -> $x {
            given @grid[$y;$x] {
                when 'E' { take Unit.new(type => Elf, :$x, :$y); }
                when 'G' { take Unit.new(type => Goblin, :$x, :$y); }
            }
        }
    }
}

class Coord { has $.x; has $.y; }
class Path { has Coord @.steps; method distance { +@!steps; }; method first { @!steps.head; } }

class Unit {
    has Type $.type; has $.x is rw; has $.y is rw; has $.hp is rw = 200;
    multi method gist { "{$!type} {$!x},{$!y} - {$!hp}"; }

    my $attack-power = 3;
    method coord($x, $y) { Coord.new(:$x, :$y); }
    method enemies { @units.grep(*.type != $!type); };
    method distance(Unit $other) { abs($other.x - $!x) + abs($other.y - $!y); }
    method adjacent { self.enemies.grep({ .distance(self) == 1 }).sort({ .hp }); }
    method targets { @units
                     .flatmap({ .coord(.x-1,.y), .coord(.x,.y-1), .coord(.x+1,.y), .coord(.x,.y+1) })
                     .min({ abs(.x - $!x) + abs(.y - $!y) }); }
    method paths(Coord $dest) { Path.new(steps=>(Coord.new(x=>$!x+1, :$!y),)) }
    method move { my @paths = self.paths(self.targets.sort({.y, .x}).head);
                  my $to = @paths.head.first; self.clear; $!x = $to.x; $!y = $to.y; self.draw }
    method attack($other) { $other.hp = max(0, $other.hp - $attack-power); }

    method clear { mvaddstr($!y, $!x, '.'); }
    method draw { mvaddstr($!y, $!x, $!type == Elf ?? 'E' !! 'G'); }
}

sub draw {
    for 0..^32 -> $y { for 0..^32 -> $x { printw @grid[$y;$x]; }; printw "\n"; }
    nc_refresh;
}

my $win = initscr;
die "Failed to initialize ncurses" unless $win.defined;

draw;

for 1..30 -> $round {
    for @units.sort({ .y, .x }) -> $u {
        my @adjacencies = $u.adjacent;
        if +@adjacencies == 0 { $u.move; @adjacencies = $u.adjacent; }
        if +@adjacencies > 0 { $u.attack(@adjacencies.head); }
        mvaddstr(32, 0, "{$round}");
        nc_refresh;
        sleep 0.005;
    }
}

while getch() < 0 { };
endwin;
