package Ohess::Static;

use 5.010;
use strict;
use warnings;

use Avocado;

use File::stat;
use FindBin;
use MIME::Types;
use Carp 'croak';

# Static
get '^/static/(.*)$' => sub {
    my $file = shift;

    my $filename = sprintf(
        "%s/%s/%s",
        $FindBin::Bin,
        'static',
        $file
    );

    # Abort on file not found
    return abort(404)
      unless (-r $filename);
    
    # File exists and is readable, open and process
    my $mt = MIME::Types->new();
    my $mime = $mt->mimeTypeOf($filename);

    open(my $raw_h, $filename);
    my $raw = join("", <$raw_h>);
    close($raw_h);

    Avocado::Response->new(
        status => 200,
        content_type => $mime,
        body => $raw
    );
};

1;
