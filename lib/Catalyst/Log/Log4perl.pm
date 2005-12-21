package Catalyst::Log::Log4perl;

=head1 NAME

Catalyst::Log::Log4perl - Log::Log4perl logging for Catalyst

=head1 SYNOPSIS

In MyApp.pm:

    use Catalyst::Log::Log4perl;
    MyApp->log(
        Catalyst::Log:Log4perl->new("log4perl.conf")
    );

And later...

    $c->log->debug("This is using log4perl!");

=head1 DESCRIPTION

This module provides a L<Catalyst::Log> implementation that uses 
L<Log::Log4perl> as the underlying log mechanism.  It provides all
the methods listed in L<Catalyst::Log>, with the exception of:

    levels
    enable
    disable

These methods simply return 0 and do nothing, as similar functionality
is already provided by L<Log::Log4perl>.

These methods will all instantiate a logger with the component set to 
the package who called it.  For example, if you were in the 
MyApp::C::Main package, the following:

    package MyApp::C::Main;

    sub default : Private {
        my ( $self, $c ) = @_;
        my $logger = $c->log;
        $logger->debug("Woot!");
    }

Would send a message to the Myapp.C.Main L<Log::Log4perl> component.

See L<Log::Log4perl> for more information on how to configure different 
logging mechanisms based on the component.

=head1 METHODS

=over 4

=cut

use strict;
use Log::Log4perl;
use Log::Log4perl::Layout;
use Log::Log4perl::Level;
use Params::Validate;

our $VERSION = '0.1';

=item new($config)

This builds a new L<Catalyst::Log::Log4perl> object.  If you provide an argument
to new(), it will be passed directly to Log::Log4perl::init.  

Without any arguments, it will initialize a root logger with a single appender,
L<Log::Log4perl::Appender::Screen>, configured to have an identical layout to
the default L<Catalyst::Log> object.

=cut
sub new {
    my $self = shift;
    my $config = shift;
    my %foo;
    my $ref = \%foo;
    unless (Log::Log4perl->initialized) {
        if (defined($config)) {
            Log::Log4perl::init($config);
        } else {
            my $log = Log::Log4perl->get_logger("");
            my $layout = Log::Log4perl::Layout::PatternLayout->new("[%d] [catalyst] [%p] %m%n");
            my $appender = Log::Log4perl::Appender->new(
                "Log::Log4perl::Appender::Screen",
                'name' => 'screenlog',
                'stderr' => 1,
            );
            $appender->layout($layout);
            $log->add_appender($appender);
            $log->level($DEBUG);
        }
    }
    bless $ref, $self;
    return $ref;
}

=item debug($message)

Passes it's arguments to $logger->debug.

=cut
sub debug {
    my ($self, @message) = @_;
    my ($package, $filename, $line) = caller;
    my $depth = $Log::Log4perl::caller_depth;
    unless ($depth > 0) {
        $depth = 1;
    }
    local $Log::Log4perl::caller_depth = $depth;
    my $logger = Log::Log4perl->get_logger($package);
    $logger->debug(@message);
    return 1;
}

=item info($message)

Passes it's arguments to $logger->info.

=cut
sub info {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $depth = $Log::Log4perl::caller_depth;
    unless ($depth > 0) {
        $depth = 1;
    }
    local $Log::Log4perl::caller_depth = $depth;
    my $logger = Log::Log4perl->get_logger($package);
    $logger->info(@message);
    return 1;
}

=item warn($message)

Passes it's arguments to $logger->warn.

=cut
sub warn {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $depth = $Log::Log4perl::caller_depth;
    unless ($depth > 0) {
        $depth = 1;
    }
    local $Log::Log4perl::caller_depth = $depth;
    my $logger = Log::Log4perl->get_logger($package);
    $logger->warn(@message);
    return 1;
}

=item error($message)

Passes it's arguments to $logger->error.

=cut
sub error {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $depth = $Log::Log4perl::caller_depth;
    unless ($depth > 0) {
        $depth = 1;
    }
    local $Log::Log4perl::caller_depth = $depth;
    my $logger = Log::Log4perl->get_logger($package);
    $logger->error(@message);
    return 1;
}

=item fatal($message)

Passes it's arguments to $logger->fatal.

=cut
sub fatal {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $depth = $Log::Log4perl::caller_depth;
    unless ($depth > 0) {
        $depth = 1;
    }
    local $Log::Log4perl::caller_depth = $depth;
    my $logger = Log::Log4perl->get_logger($package);
    $logger->fatal(@message);
    return 1;
}

=item is_debug()

Calls $logger->is_debug.

=cut
sub is_debug {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $logger = Log::Log4perl->get_logger($package);
    return $logger->is_debug;
}

=item is_info()

Calls $logger->is_info.

=cut
sub is_info {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $logger = Log::Log4perl->get_logger($package);
    return $logger->is_info;
}

=item is_warn()

Calls $logger->is_warn.

=cut
sub is_warn {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $logger = Log::Log4perl->get_logger($package);
    return $logger->is_warn;
}

=item is_error()

Calls $logger->is_error.

=cut
sub is_error {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $logger = Log::Log4perl->get_logger($package);
    return $logger->is_error;
}

=item is_fatal()

Calls $logger->is_fatal.

=cut
sub is_fatal {
    my ($self, @message)  = @_;
    my ($package, $filename, $line) = caller;
    my $logger = Log::Log4perl->get_logger($package);
    return $logger->is_fatal;
}

=item levels()

This method does nothing but return "0".  You should use L<Log::Log4perl>'s
built in mechanisms for setting up log levels.

=cut
sub levels {
    return 0;
}

=item enable()

This method does nothing but return "0".  You should use L<Log::Log4perl>'s
built in mechanisms for enabling log levels.

=cut
sub enable {
    return 0;
}

=item disable()

This method does nothing but return "0".  You should use L<Log::Log4perl>'s
built in mechanisms for disabling log levels.

=cut
sub disable {
    return 0;
}

1;

__END__
=back

=head1 SEE ALSO

L<Log::Log4perl>, L<Catalyst::Log>, L<Catalyst>.

=head1 AUTHOR

Adam Jacob, C<adam@stalecoffee.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as perl itself.

=cut
