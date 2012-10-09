package Ohess::Projects;

use 5.010;
use strict;
use warnings;

use Text::Textile;
use File::stat;
use FindBin;
use JSON;

use Ohess::Backend;
use Ohess::Config;
use Ohess::Buildbot;

# Index
get '^/projects/([A-Za-z0-9\_\-\.]+)[/]*$' => sub {
    my ($request, $id) = @_;
    my $section = 'project';

    # Textile for text
    my ($filename, $title, $date, $meta, $args, $body);
    $filename = sprintf('%s/%s/%s.txtl', $FindBin::Bin, $section, $id);

    unless (-r $filename) {
        return sub { shift->(abort(404)) };
    }

    return sub {
        my $respond = shift;

        # File exists and is readable, open and process
        open(TXTL, $filename);
        my $txtl_h = join('', <TXTL>);
        my $txtl = Text::Textile->new();
        $txtl->{_line_close} = '';
        $body = $txtl->process($txtl_h);
        close(TXTL);

        # Get page meta data, build args
        $meta = Ohess::Config::pub($id);
        $date = localtime(stat($filename)->mtime);
        $args = {
            body => $body,
            section => $section,
            id => $id,
            meta => $meta,
            date => $date,
            share => 1,
        };

        # Return template
        my $res = template("${section}.tt", $args);
        $res->headers->header('Cache-Control' => 'max-age=7200');
        return $respond->(render $res);
    };
};

get '^/projects/([A-Za-z0-9\_\-\.]+)/stats.json$' => sub {
    my ($request, $id) = @_;

    return sub {
        my $respond = shift;
        my $obj = Ohess::Buildbot::stats($id);
        my $json = JSON->new->allow_nonref;
        my $res = Plack::Response->new(
            200,
            {
                'Content-type' => 'application/json',
                'Cache-Control' => 'max-age=7200'
            },
            [$json->encode($obj)]
        );
        return $respond->(render $res);
    };
};

