package Net::Services;

=head1 NAME

Net::Services - tied interface to the /etc/services file

=head1 SYNOPSIS

    use Net::Services;
    tie my %services, 'Net::Services';

    print "Port 23 is $services{23}\n";
    print qq[Port 23 tcp is $services{"23-tcp"}\n];

=head1 DESCRIPTION

Constructs a hash from the /etc/services file and provides a tied
interface to it that takes care of things like the protocol name.

=cut

use strict;
use warnings;
use IO::File;

our ( $VERSION ) = '$Revision: 1.3 $ ' =~ /\$Revision:\s+([^\s]+)/;

my $etc = '/etc/services';

my %svcs;

my @prots = qw/tcp udp ucp ddp/;
my $prot_RE = join('|', @prots);
$prot_RE = qr/$prot_RE/;

my $input = IO::File->new($etc) or die "Cannot open $etc for reading: $!\n";
while (<$input>)
{
    chomp;
    s/\s*#.*$//;
    next if /^\s*$/;
    next unless m/^
	\s*
	([\w.+-]+)
	\s+
	(\d+)\/($prot_RE)
	\s*
	([\w\s.+-]*)
    $/x;
    $svcs{"$2-$3"} = $1;
}
$input->close;

# ========================================================================
#                                                          Private Methods

=begin private

=head1 PRIVATE METHODS

=over 4

=item $obj = Net::Services->TIEHASH()

Creates a new Net::Services object.

=cut

sub TIEHASH
{
    my $class = shift;
    $class = ref($class) || $class;
    my $self = bless {}, $class;
}

=item $obj->STORE($key, $data)

Not implemented.

=cut

sub STORE
{
}

=item $name = $obj->FETCH(22)

Returns the name of the given service, or undef.

It tries assorted protocols given just a number, or if given a protocol
it tries just that protocol.

  $name = $obj->FETCH('22-tcp');

=cut

sub FETCH
{
    my ($self, $key) = @_;
    return $svcs{$key} if exists $svcs{$key};
    return undef if $key =~ /-/;
    foreach (@prots)
    {
	return $svcs{"$key-$_"} if exists $svcs{"$key-$_"};
    }
    return undef;
}

=item print "It exists!\n" if $obj->EXISTS($key);

Returns true if the key exists, false otherwise.

=cut

sub EXISTS
{
    my ($self, $key) = @_;
    return ($self->FETCH($key) ? 1 : 0);
}

=item $obj->FIRSTKEY()

Returns the first key of the cache.

=cut

sub FIRSTKEY
{
    my ($self) = @_;
    my $impl = \%svcs;
    keys %$impl;
    my $first_key = each %$impl;
    return undef unless defined $first_key;
    return $first_key;
}

=item $obj->NEXTKEY()

Returns the next key of the cache.

=cut

sub NEXTKEY
{
    my ($self, $nextkey) = @_;
    my $impl = \%svcs;
    my $next_key = each %$impl;
    return undef unless defined $next_key;
    return $next_key;
}

=item $obj->CLEAR()

Not implemented.

=cut

sub CLEAR
{
}

=item $obj->DELETE($key)

Not implemented.

=cut

sub DELETE
{
}

=back

=end private

=cut

1;

__END__
#
# ========================================================================
#                                                Rest Of The Documentation

=head1 AUTHOR

Iain Truskett <spoon@cpan.org> L<http://eh.org/~koschei/>

Please report any bugs, or post any suggestions, to either the mailing
list at <cpan@dellah.anu.edu.au> (email
<cpan-subscribe@dellah.anu.edu.au> to subscribe) or directly to the
author at <spoon@cpan.org>

=head1 BUGS

None known at present.

=head1 PLANS

None at present.

=head1 COPYRIGHT

Copyright (c) 2002 Iain Truskett. All rights reserved. This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

    $Id: Services.pm,v 1.3 2002/03/23 15:56:44 koschei Exp $

=head1 ACKNOWLEDGEMENTS

Yeah. Hmm.

=head1 SEE ALSO

Um.
