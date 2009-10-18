use inc::Module::Install 0.87;

name 'Catalyst-Log-Log4perl';
all_from 'lib/Catalyst/Log/Log4perl.pm';
requires( 'Catalyst'         => '5.60' );
requires( 'Log::Log4perl'    => '1.04');
requires( 'Params::Validate' => 0 );
requires( 'Data::Dump' => 0 );
requires( 'MRO::Compat' => 0 );

auto_include;
auto_install;

resources repository => 'http://dev.catalyst.perl.org/repos/Catalyst/trunk/Catalyst-Log-Log4perl/';

WriteAll
