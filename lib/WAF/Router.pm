package WAF::Router;
use strict;
use warnings;
use Class::Load qw(load_class);

use Exporter qw(import);
our @EXPORT_OK = qw(GET POST router);
our %EXPORT_TAGS = ( declare => \@EXPORT_OK );

# same as Router::Simple...
our $_ROUTER;

sub router (&) {
    my $cb = shift;
    local $_ROUTER = WAF::Router->new;
    $cb->();
    $_ROUTER->compile;
    $_ROUTER;
}

sub GET {
    $_ROUTER->register( GET => @_ );
}
sub POST {
    $_ROUTER->register( POST => @_ );
}

sub new {
    my $class = shift;
    my $self = bless { GET => +{}, POST => +{} }, $class;
    $self->register(@_);
}

sub register {
    my ($self, @arg) = @_;
    while ( my ($req_method, $req_path, $to) = splice @arg, 0, 3 ) {
        my ($klass, $method) = split /#/, $to, 2;
        %{ $self->{ $req_method } } = (
            %{ $self->{ $req_method } },
            $req_path => [ $klass, $method ],
        );
    }
    $self;
}

sub compile {
    my $self = shift;
    my %klass;
    for my $to ( values(%{ $self->{GET} }), values(%{ $self->{POST} }) ) {
        push @{ $klass{ $to->[0] } }, $to->[1];
    }

    for my $klass (keys %klass) {
        load_class $klass;
        my $instance = $klass->new;
        for my $method (@{ $klass{$klass} }) {
            $instance->can( $method )
                or die "ERROR: $klass does not have method $method";
        }
        $self->{instance}{ $klass } = $instance;
    }
    $self;
}

sub match {
    my $self = shift;
    my $env  = shift;
    my $req_method = $env->{REQUEST_METHOD};
    my $req_path   = $env->{PATH_INFO};
    for my $path ( keys %{ $self->{ $req_method } } ) {
        if ($path eq $req_path) {
            my $to = $self->{ $req_method }{ $path };
            return ( $self->{instance}{ $to->[0] }, $to->[1] );
        }
    }
    return;
}


1;

