package Ohess::Pages;

use 5.010;
use strict;
use warnings;

use Avocado;

use Text::Textile;
use File::stat;
use FindBin;

use Ohess::Config;
use Ohess::Buildbot;

# Index
get '^[/]*$' => sub { return redirect('/index'); };
get '^/index$' => sub {
    my $meta = Ohess::Config::page('index');

    my $res = template("index.tt", { 
      section => "page",
      id => "index",
      title => "index",
      meta => $meta
    });
    $res->headers->header('Cache-Control' => 'max-age=7200');

    return $res;
};

# Publication list
get '^/pub[/]?$' => sub {
    my $pubs = Ohess::Config::pubs();

    my $res = template("pubs.tt", { 
      section => "page",
      id => "pub",
      title => "publications",
      pubs => $pubs
    });
    $res->headers->header('Cache-Control' => 'max-age=7200');
    
    return $res;
};

# Textile processing for pages and notes
get '^/(pub|projects)/((?:[A-Za-z0-9\_\-]+/|)[A-Za-z0-9\_\-\.]+)[/]*$' => 
  sub { return process_textile(@_); }; 
get '^/(projects|about|colophon|honeypot)[/]*$' => 
  sub { return process_textile("page", @_); };

sub process_textile {
    my $section = shift;
    my $id = shift;

    given ($section) {
        when (/^pub[s]?/) { $section = "pub"; }
        when (/^project[s]?/) { $section = "project"; }
        when (/^page[s]?/) { $section = "page"; } 
    }

    my $filename = sprintf("%s/%s/%s.txtl", $FindBin::Bin, $section, $id);

    if (-r $filename) {
        my $title;
        my $date;
        my $meta;
        my $args;

        # File exists and is readable, open and process
        open(TXTL, $filename);
        my $txtl_h = join("", <TXTL>);
        my $txtl = Text::Textile->new();
        $txtl->{_line_close} = "";
        my $body = $txtl->process($txtl_h);
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
        
        # Extra arguments
        if ($section eq "project" or $id eq "projects") {
            $args->{build_stats} = sub { Ohess::Buildbot::stats(@_); };
        }

        # Return template
        my $res = template("$section.tt", $args);
        $res->headers->header('Cache-Control' => 'max-age=7200');

        return $res;
    }
    else {
        # Return 404 error
        return abort(404);
    }
};

1;
