#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Delay::Fibonacci' ) || print "Bail out!\n";
}

diag( "Testing Delay::Fibonacci $Delay::Fibonacci::VERSION, Perl $], $^X" );
