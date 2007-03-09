#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 14;
use FindBin;

use lib ( "$FindBin::Bin/lib", "$FindBin::Bin/../lib" );

BEGIN {
    use_ok "Catalyst::Log::Log4perl";
    use_ok "MockApp";
}

MockApp->setup;

my $app = MockApp->new();
my $c   = undef;

isa_ok( $app, 'MockApp' );

# fetch the single appender so we can access log messages
my ($appender) = values %{ Log::Log4perl->appenders };
isa_ok( $appender, 'Log::Log4perl::Appender' );

sub log_ok($;$) {
    my ( $check, $msg ) = @_;
    is( $appender->string, $check, $msg );
    $appender->string('');
}

sub log_like($;$) {
    my ( $re, $msg ) = @_;
    like( $appender->string, $re, $msg );
    $appender->string('');
}

## test capturing of log messages

$c = $app->GET('/foo');
is( $c->response->body, 'foo', 'Foo response body' );
log_ok( '[MockApp.Controller.Root] root/foo', 'Foo log message' );

$c = $app->GET( '/bar', 'say=hello' );
is( $c->response->body, 'hello', 'Bar response body' );
log_ok( '[MockApp.Controller.Root] root/bar', 'Bar log message' );

## test different cseps

# %F File where the logging event occurred

$appender->layout( Log::Log4perl::Layout::PatternLayout->new('%F') );
$c = $app->GET('/foo');
log_like( qr|lib/MockApp/Controller/Root.pm$|, 'Loggin filepath' );

$appender->layout( Log::Log4perl::Layout::PatternLayout->new('%L') );
$c = $app->GET('/foo');
log_ok( '18', 'Loggin line number' );

# %C Fully qualified package (or class) name of the caller

$appender->layout( Log::Log4perl::Layout::PatternLayout->new('%C') );
$c = $app->GET('/foo');
log_ok( 'MockApp::Controller::Root', 'Loggin class name' );

# %l Fully qualified name of the calling method followed by the
#    callers source the file name and line number between
#    parentheses.

$appender->layout( Log::Log4perl::Layout::PatternLayout->new('%l') );
$c = $app->GET('/foo');
log_like
qr|^MockApp::Controller::Root::foo .*lib/MockApp/Controller/Root.pm \(18\)$|,
  'Loggin location';

# %M Method or function where the logging request was issued

$appender->layout( Log::Log4perl::Layout::PatternLayout->new('%M') );
$c = $app->GET('/foo');
log_ok( 'MockApp::Controller::Root::foo', 'Loggin method' );

# %T A stack trace of functions called

# unimplemented: would cause a major performance hit

## check another log message to ensure the closures work correctly

$appender->layout( Log::Log4perl::Layout::PatternLayout->new('%L') );
$c = $app->GET('/bar');
log_ok( '24', 'Loggin another line number' );
