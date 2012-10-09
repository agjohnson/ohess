package Ohess;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.01';

use Ohess::Backend;
use Ohess::Pages;
use Ohess::Projects;

use Plack::Builder;
use Plack::Middleware::Static;

sub app {
    builder {
        enable(
            "Plack::Middleware::Static",
            path => sub { s#^/static/## },
            root => 'static/'
        );
        mount '/' => \&Ohess::Backend::app;
    }
}

1;
