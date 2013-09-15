# NAME

WAF - PSGI WAF

# SYNOPSIS

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



# DESCRIPTION

WAF is a PSGI waf.

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@outlook.com>
