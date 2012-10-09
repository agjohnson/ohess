package Ohess::Pages;

use 5.010;
use strict;
use warnings;

use Text::Textile;
use File::stat;
use FindBin;
use Plack::Response;

use Ohess::Backend;
use Ohess::Config;

# Index
get '^[/]*$' => sub {
    return sub {
        my $respond = shift;
        my $ret = Plack::Response->new();
        $ret->redirect('/index', 302);
        return $respond->(render $ret);
    };
};

get '^/index$' => sub {
    return sub {
        my $respond = shift;
        my $meta = Ohess::Config::page('index');

        my $res = template('index.tt', {
            section => 'page',
            id => 'index',
            title => 'index',
            meta => $meta
        });
        $res->headers->header('Cache-Control' => 'max-age=7200');
        return $respond->(render $res);
    };
};

# Publication list
get '^/pub[/]?$' => sub {
    return sub {
        my $respond = shift;
        my $pubs = Ohess::Config::pubs();

        my $res = template('pubs.tt', {
            section => 'page',
            id => 'pub',
            title => 'publications',
            pubs => $pubs
        });
        $res->headers->header('Cache-Control' => 'max-age=7200');
        return $respond->(render $res);
    }
};

# Textile processing for pages and notes
get '^/pub/((?:[A-Za-z0-9\_\-]+/|)[A-Za-z0-9\_\-\.]+)[/]*$' =>
  sub { return process_textile('pub', @_); };
get '^/(projects|about|colophon|honeypot)[/]*$' =>
  sub { return process_textile('page', @_); };

sub process_textile {
    my ($section, $req, $id) = @_;

    given ($section) {
        when (/^pub[s]?/) { $section = 'pub' }
        when (/^page[s]?/) { $section = 'page' }
    }

    my $filename = sprintf('%s/%s/%s.txtl', $FindBin::Bin, $section, $id);
    say 'FILENAME: ', $filename;

    if (-r $filename) {
        return sub {
            my $respond = shift;
            my $title;
            my $date;
            my $meta;
            my $args;

            use Data::Dumper;
            say 'RESPOND: ', Dumper($respond);

            # File exists and is readable, open and process
            open(TXTL, $filename);
            my $txtl_h = join('', <TXTL>);
            my $txtl = Text::Textile->new();
            $txtl->{_line_close} = '';
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

            my $res = template("$section.tt", $args);
            $res->headers->header('Cache-Control' => 'max-age=7200');
            return $respond->(render $res);
        }
    }
    else {
        return sub {
            return shift->(abort(404));
        }
    }
};

1;
