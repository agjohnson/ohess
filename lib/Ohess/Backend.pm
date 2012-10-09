package Ohess::Backend;

use 5.010;
use strict;
use warnings;

use Plack::Response;
use Plack::Request;
use Template;
use FindBin;
use Cwd;

use Exporter 'import';
our @EXPORT = qw/
    route get post put delete
    template render abort
/;

our $Path = Cwd::abs_path($FindBin::Bin . "/view");
our $Routes = {};

sub app {
    my $env = shift;

    my $req = Plack::Request->new($env);
    my $path = $req->path_info;
    my $method = $req->method;

    foreach my $route (@{$Routes->{$method}}) {
        my $route_path = $route->{path};
        if (my @args = ($path =~ m#$route_path#)) {
            return $route->{callback}($req, @args);
        }
    }

    return abort(404);
}

# Building routes
sub route {
    my ($method, $path, $callback) = @_;
    push(@{$Routes->{uc $method}}, {
        path => $path,
        callback => $callback
    });
}

sub get ($&) { route('GET', @_) }
sub post ($&) { route('POST', @_) }
sub put ($&) { route('PUT', @_) }
sub delete ($&) { route('DELETE', @_) }

# Return HTTP failure
sub abort ($) {
    my $code = shift;
    return render(template('error.tt', { error => $code }));
}

# Return response rendered from TT2 template
sub template ($;$) {
    my ($template, $args) = @_;

    # Try to process the template, croak on errors, return response
    my $output = "";
    my $t = Template->new({
        INCLUDE_PATH => $Path,
    }) or die "Error setting up template processor";

    $t->process($template, $args, \$output)
      or die "Problem with template $@";

    return Plack::Response->new(
        200,
        {'Content-type' => 'text/html'},
        [$output]
    );
}

# Renders a response
sub render ($) {
    my $val = shift;
    if (ref $val eq 'Plack::Response') {
        return $val->finalize;
    }
    return Plack::Response->new(
        200,
        {'Content-type' => 'text/html'},
        [$val]
    )->finalize;
}

1;
