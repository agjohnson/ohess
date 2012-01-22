use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Ohess',
    VERSION_FROM      => 'lib/Ohess.pm', # finds $VERSION
    PREREQ_PM         => {
        'LWP::Simple' => 0,
        'LWP::UserAgent' => 0,
        'JSON' => 0,
        'Text::Textile' => 0,
        'File::stat' => 0,
        'FindBin' => 0,
        'FCGI' => 0,
        'FCGI::ProcManager' => 0,
        'Getopt::Long' => 0,
        'Test::Harness' => 0,
        'Avocado' => 0,
        'Plack' => 0,
        'Plack::Handler::FCGI' => 0,
        'YAML' => 0,
        'Scalar::Util' => 0
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Ohess.pm', # retrieve abstract from module
       AUTHOR         => 'Anthony Johnson <aj@ohess.org>') : ()),
);
