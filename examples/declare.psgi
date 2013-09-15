#!/usr/bin/env perl
use strict;
use warnings;

package Controller;
sub new {
    bless {}, shift;
}
sub index {
    my $env = shift;
    [ 200, [], ['Hello, World!'] ];
}

package main;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WAF;
use WAF::Router ':declare';

my $router = router {
    GET '/' => "Controller#index";
};

WAF->new(router => $router)->to_psgi;
