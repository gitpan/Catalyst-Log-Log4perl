package MockApp;

BEGIN { $ENV{CATALYST_ENGINE} = 'HTTP' }

use strict;
use warnings;

use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_ro_accessors('context');

use Catalyst;
use Catalyst::Log::Log4perl;
use Catalyst::Runtime;
use Sub::Install;
use NEXT;

our %config = ( name => 'MockApp', home => './t/' );
sub config { \%config }

__PACKAGE__->log(
    Catalyst::Log::Log4perl->new( \<<CONF, override_cspecs => 1 ) );
log4perl.rootLogger=WARN, LOG
log4perl.appender.LOG=Log::Log4perl::Appender::String
log4perl.appender.LOG.layout=PatternLayout
log4perl.appender.LOG.layout.ConversionPattern=[%c] %m
CONF

sub new {
    my $class = shift;
    my $self  = $class->NEXT::new(@_);

    my $finalize = \&Catalyst::finalize;
    Sub::Install::reinstall_sub(
        {
            code => sub {
                my $c = shift;
                $self->{context} = $c;
                $finalize->($c);
            },
            into => qw/Catalyst/,
            as   => 'finalize',
        }
    );

    return $self;
}

sub setup {
    my $class = shift;
    my $res   = $class->NEXT::setup(@_);

    Sub::Install::reinstall_sub(
        {
            code => sub {

                #unneded
            },
            into => qw/Catalyst::Engine::HTTP/,
            as   => 'write',
        }
    );
    Sub::Install::reinstall_sub(
        {
            code => sub {

                #unneded
            },
            into => qw/Catalyst::Engine::HTTP/,
            as   => 'finalize_headers',
        }
    );

    return $res;
}

sub GET {
    my $self  = shift;
    my $path  = shift || '/';
    my $query = join( '&', @_ ) || '';
    local %ENV = (
        PATH_INFO       => $path,
        QUERY_STRING    => $query,
        REMOTE_ADDR     => '127.0.0.1',
        REMOTE_HOST     => 'cll4p.test.loc',
        REQUEST_METHOD  => 'GET',
        SERVER_NAME     => 'MockApp',
        SERVER_PORT     => 3000,
        SERVER_PROTOCOL => "HTTP/1.0",
    );
    $self->handle_request;
    return $self->context;
}

1;
