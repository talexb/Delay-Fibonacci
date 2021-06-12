package Delay::Fibonacci;

use 5.006;
use strict;
use warnings;

 use Time::HiRes qw/sleep/;

=head1 NAME

Delay::Fibonacci - The great new Delay::Fibonacci!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Delay::Fibonacci;

    my $foo = Delay::Fibonacci->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

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
