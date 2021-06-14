package Delay::Fibonacci;

use 5.006;
use strict;
use warnings;

 use Time::HiRes qw/sleep/;

=head1 NAME

Delay::Fibonacci - Useful for retries, implements a Fibonacci backoff delay

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module implements a delay with Fibonacci backoff.

In the example below, a step size of .1 and a retry count of 5 will result in
delays of .1, .1, .2, .3 and .5 seconds.

Perhaps a little code snippet.

    use Delay::Fibonacci;

    #  Start with a step size of .1 seconds and 5 retries.
    #  We'll track the operation status as well as the
    #  fibonacci status.

    my $fib = Delay::Fibonacci->new({ step => .1, retry => 5});
    my ( $op_status, $fib_status );

    #  This loop does the operation, and if it fails, we call
    #  the delay method to pause.

    #  If the operation succeeded, we're done. Otherwise,
    #  we loop again as long as the delay returns OK, because
    #  we still have retries left.

    #  If we fall out of the do .. while loop, that means we
    #  failed again, and all of the retries were exhausted.

    do {

      #  This value is defined if the operation succeeds.
      $op_status = operation_that_may_fail();

      if ( !defined $op_status ) { $fib_status = $fib->delay; }

    } while ( !$op_status && $fib_status );

    if ( !defined $op_status ) {

      $log->error ( "Failed operation after " . $fib->duration .
        " seconds" );
    }

    ...

If the operation failed after all of those retries, the total time spent can be
retrieved, in case that's useful information.

=head1 METHODS

=head2 Delay::Fibonacci->new( ... )

This method accepts two arguments: step (step size in fractional seconds) and
retry (retry count). A non-zero step and a retry count of less than two cause
errors that can be found in $Delay::Fibonacci::ErrStr.

The default step size is 1 second, and the default retry count is 5.

The Time::HiRes module is used to deal with sub-second times.

=head2 Delay::Fibonacci->duration

This method reports the total amount of time delayed.

=cut

our $ErrStr;

sub new
{
    my ( $class, $args ) = @_;

    #  Check that the arguments are rational. The step needs to be non-zero and
    #  positive, and the retry count should be greater than one.

    my @errors;
    if ( defined $args->{step} && $args->{step} <= 0 ) {

        push( @errors, 'Step size must be positive' );
    }

    if ( defined $args->{retry} && $args->{retry} < 2 ) {

        push( @errors, 'Retry count must be greater than one' );
    }

    if ( @errors ) {

        $ErrStr = join ( ' / ', @errors );
        return undef;
    }

    #  Initialize the step size and the retry count ..

    my $step = $args->{step} // 1;
    my $retry = $args->{retry} // 5;

    #  .. then build the array of delays to those specifications.

    my @array = ( $step, $step );
    for ( my $size = scalar ( @array ); $size < $retry; $size++ ) {

        push ( @array, $array[-2] + $array[-1] );
    }
    my $self = { delay => \@array, duration => 0 };

    bless $self, $class;
    return $self;
}

sub delay
{
    my $self = shift;

    if ( @{$self->{delay}} == 0 ) {

        return undef;   #  We're out of retries.
    }

    $self->{ duration } += $self->{delay}->[0];
    sleep shift @{ $self->{delay} };

    return 1;           #  We just did a delay.
}

sub duration
{
    my $self = shift;

    return $self->{ duration };
}

=head1 AUTHOR

T. Alex Beamish, C<< <talexb at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-delay-fibonacci at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Delay-Fibonacci>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Delay::Fibonacci


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Delay-Fibonacci>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Delay-Fibonacci>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Delay-Fibonacci>

=item * Search CPAN

L<https://metacpan.org/release/Delay-Fibonacci>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2021 by T. Alex Beamish.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1; # End of Delay::Fibonacci
