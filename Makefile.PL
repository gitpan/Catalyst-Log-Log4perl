use inc::Module::Install;

name 'Catalyst-Log-Log4perl';
all_from 'lib/Catalyst/Log/Log4perl.pm';
requires( 'Catalyst'         => '5.60' );
requires( 'Params::Validate' => 0 );
requires( 'Sub::Install'     => 0 );

auto_include;
auto_install;

WriteAll
