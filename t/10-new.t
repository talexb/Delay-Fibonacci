#!/usr/bin/perl

use 5.006;
use strict;
use warnings;

use Test::More;
use Time::HiRes qw/gettimeofday tv_interval/;

use Delay::Fibonacci;

use constant {
    STEP_SIZE   => .001,
    RETRY_COUNT => 10,
};

{
    my $fib = Delay::Fibonacci->new( { step => STEP_SIZE, retry => RETRY_COUNT } );

    ok( defined $fib, 'Fib object created' );

    my @exp_delays = ( STEP_SIZE, STEP_SIZE );
    while ( scalar @exp_delays < RETRY_COUNT ) {

        push ( @exp_delays, $exp_delays[ -1 ] + $exp_delays[ -2 ] );
    }

    foreach my $this_delay (@exp_delays) {

        my $start  = [gettimeofday];
        my $status = $fib->delay;
        my $stop   = [gettimeofday];

        my $diff = tv_interval( $start, $stop );

        is( $status, 1, 'Good status back from first delay' );
        cmp_ok( $diff, '>', $this_delay, "First sleep at least $this_delay" );
        cmp_ok(
            $diff, '<',
            $this_delay + STEP_SIZE,
            "First sleep less than " . ($this_delay + STEP_SIZE)
        );
    }

    my $status = $fib->delay;
    ok( !defined $status, 'Bad status back after last delay' );

    done_testing;
}
