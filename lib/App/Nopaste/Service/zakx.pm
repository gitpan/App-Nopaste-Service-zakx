#!perl
use strict;
use warnings;

package App::Nopaste::Service::zakx;
{
  $App::Nopaste::Service::zakx::VERSION = '0.001';
}
use Encode qw( decode_utf8 );

use base q[App::Nopaste::Service];

# ABSTRACT: L<App::Nopaste> interface to L<http://np.zakx.de>

my $languages = {
    c      => 'C',
    'c++'  => 'C++',
    c89    => 'C89',
    csharp => 'C#',
    java   => 'Java',
    mirc   => 'mIRC',
    'pl/i' => 'PL/I',
    pascal => 'Pascal',
    perl   => 'Perl',
    php    => 'PHP',
    python => 'Python',
    ruby   => 'Ruby',
    scheme => 'Scheme',
    sql    => 'SQL',
    text   => 'Plain Text',
    vb     => 'VB',
    xml    => 'XML',
};
sub uri {'http://np.zakx.de/'}

sub get {
    my ( $self, $mech ) = @_;

    return $mech->get( $self->uri );
}

sub fill_form {
    my ( $self, $mech, %args ) = @_;

    my $lang = $args{lang} || 'text';

    return $mech->submit_form(
        fields => {
            code      => $args{text},
            code_lang => $languages->{$lang},
            ( $args{desc} ? ( name => $args{desc} ) : () ),
        },
        button => 'submit',
    );
}

sub return {
    my ( $self, $mech ) = @_;

    my ($link)
        = ( $mech->content
            =~ m{<div style="text-align:right;"><a href="/([^:]+):nl">Hide row numbers</a></div>}
        );

    return ( 1, $self->uri . $link );
}

1;

__END__

=pod

=head1 NAME

App::Nopaste::Service::zakx - L<App::Nopaste> interface to L<http://np.zakx.de>

=head1 VERSION

version 0.001

=head1 SYNOPSIS

To use, simple use:

    $ echo "text" | nopaste -s zakx

=head1 SEE ALSO

L<App::Nopaste::Command> - command-line utility for L<App::Nopaste>

=head1 AUTHOR

Benjamin Stier <ben@unpatched.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Benjamin Stier.

This program is free software. It comes without any warranty, to the extent
permitted by applicable law. You can redistribute it and/or modify it under the
terms of the Beer-ware license revision 42.

=cut
