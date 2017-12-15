#!/usr/bin/env perl6

use v6;
use Digest::MD5;

my $input = 'cxdnnyjw';

for 0..* -> $index {

    my $hash = Digest::MD5.md5_hex($input ~ $index);

    say $index if $index mod 1000 == 0;
    say $hash if $hash.starts-with('00000');
}
