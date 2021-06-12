#!/usr/bin/perl

use 5.006;
use strict;
use warnings;

use Test::More;

use Delay::Fibonacci;

{
    foreach my $step (qw/-2 -1 -.5 0/) {

        foreach my $retry (qw/-2 -1 0 1/) {

            my $fib =
              Delay::Fibonacci->new( { step => $step, retry => $retry } );

            ok( !defined $fib, 'Fib object not created' );
            like( $Delay::Fibonacci::ErrStr, qr/\w/,
                'There was an error reported' );
        }
    }

    done_testing;
}
