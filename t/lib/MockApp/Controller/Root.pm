package MockApp::Controller::Root;

use strict;
use warnings;

use base qw/Catalyst::Controller Class::Data::Inheritable/;

__PACKAGE__->mk_classdata('context');
__PACKAGE__->config->{namespace} = '';

sub auto : Private {
    my ( $self, $c ) = @_;
    $self->context($c);
}

sub foo : Local {
    my ( $self, $c ) = @_;
    $c->log->warn('root/foo');
    $c->response->body('foo');
}

sub bar : Local {
    my ( $self, $c ) = @_;
    $c->log->warn('root/bar');
    $c->response->body( $c->request->param('say') );
}

1;
