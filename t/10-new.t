#!/usr/bin/perl

use 5.006;
use strict;
use warnings;

use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;

use Delay::Fibonacci;

{
    my $fib = Delay::Fibonacci->new( { step => .1, retry => 10 } );

    ok( defined $fib, 'Fib object created' );

    my $start  = [gettimeofday];
    my $status = $fib->delay;
    my $stop   = [gettimeofday];

    my $diff = tv_interval ( $start, $stop );

    is( $status, 1, 'Good status back from first delay' );
    cmp_ok( $diff, '>', .1, 'First sleep at least .1' );
    cmp_ok( $diff, '<', .2, 'First sleep less than .2' );

    done_testing;
}
