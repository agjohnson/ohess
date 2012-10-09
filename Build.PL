use 5.010;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name => 'Ohess',
    license => 'mit',
    dist_author => q{Anthony Johnson <aj@ohess.org>},
    dist_version_from => 'lib/Ohess.pm',
    build_requires => {
        'Test::More' => 0,
        'Test::Harness' => 0
    },
    requires => {
        'perl' => 5.010,
        'LWP::Simple' => 0,
        'LWP::UserAgent' => 0,
        'JSON' => 0,
        'Template' => 0,
        'Text::Textile' => 0,
        'File::stat' => 0,
        'FindBin' => 0,
        'Getopt::Long' => 0,
        'Plack' => 0,
        'Plack::Middleware::Static' => 0,
        'YAML' => 0,
        'Scalar::Util' => 0,
        'App::local::lib::helper' => 0,
        'Twiggy' => 0,
    },
    add_to_cleanup => [ 'Ohess-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
