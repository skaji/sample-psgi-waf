package WAF;
use strict;
use warnings;
our $VERSION = "0.01";

sub new {
    my ($class, %opt) = @_;
    my $router = $opt{router};
    bless { router => $router }, $class;
}

sub to_psgi {
    my $self   = shift;
    my $router = $self->{router};
    sub {
        my $env = shift;
        if (my ($controller, $method) = $router->match($env)) {
            return $controller->$method($env);
        } else {
            return [404, [], ['Not found']];
        }
    };
}

1;
__END__

=head1 NAME

WAF - PSGI WAF

=head1 SYNOPSIS

    use WAF;
    use WAF::Router;

    package Controller;
    sub new {
        bless {}, shift;
    }
    sub index {
        my $env = shift;
        [ 200, [], ['Hello, World!'] ];
    }

    package main;
    my $router = WAF::Router->new(
        GET => '/' => 'Controller#index'
    )->compile;

    my $app = WAF->new(router => $router);
    $app->to_psgi;


=head1 DESCRIPTION

WAF is a PSGI waf.

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@outlook.comE<gt>

=cut

