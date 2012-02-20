use inc::Module::Install;

name 'Ohess';
all_from 'lib/Ohess.pm';

requires 'LWP::Simple' => 0;
requires 'LWP::UserAgent' => 0;
requires 'JSON' => 0;
requires 'Text::Textile' => 0;
requires 'File::stat' => 0;
requires 'FindBin' => 0;
requires 'FCGI' => 0;
requires 'FCGI::ProcManager' => 0;
requires 'Getopt::Long' => 0;
requires 'Test::Harness' => 0;
#requires 'Avocado' => 0;
requires 'Plack' => 0;
requires 'Plack::Handler::FCGI' => 0;
requires 'YAML' => 0;
requires 'Scalar::Util' => 0;

test_requires 'Test::More' => 0;

WriteAll;
