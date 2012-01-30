package Ohess::Projects;

use 5.010;
use strict;
use warnings;

use Avocado;

use Text::Textile;
use File::stat;
use FindBin;
use JSON;

use Ohess::Config;
use Ohess::Buildbot;

# Index
get '^/projects/([A-Za-z0-9\_\-\.]+)[/]*$' => sub {
    my $id = shift;
    my $section = "project";

    # Textile for text
    my ($filename, $title, $date, $meta, $args, $body);
    $filename = sprintf("%s/%s/%s.txtl", $FindBin::Bin, $section, $id);

    return abort(404)
      unless (-r $filename);

    # File exists and is readable, open and process
    open(TXTL, $filename);
    my $txtl_h = join("", <TXTL>);
    my $txtl = Text::Textile->new();
    $txtl->{_line_close} = "";
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
    my $res = template("$section.tt", $args);
    $res->headers->header('Cache-Control' => 'max-age=7200');

    return $res;
};

get '^/projects/([A-Za-z0-9\_\-\.]+)/stats.json$' => sub {
    my $id = shift;

    my $obj = Ohess::Buildbot::stats($id);
    my $res = Avocado::Response->new(
        status => 200,
        content_type => 'text/javascript',
        body => encode_json($obj)
    );
    #$res->headers->header('Cache-Control' => 'max-age=7200');

    return $res;
};

