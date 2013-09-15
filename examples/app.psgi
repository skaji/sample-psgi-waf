#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
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
