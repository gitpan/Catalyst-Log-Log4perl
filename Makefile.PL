use ExtUtils::MakeMaker;

WriteMakefile(
    NAME      => 'Catalyst::Log::Log4perl',
    AUTHOR    => 'Adam Jacob (adam@stalecoffee.org)',
    PREREQ_PM => {
        Catalyst           => '5.30',
        'Log::Log4perl' => 0,
    },
    VERSION_FROM => 'lib/Catalyst/Log/Log4perl.pm'
);
