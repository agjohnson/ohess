package Ohess::Textile;

use 5.010;
use strict;
use warnings;

use Text::Textile;
use File::stat;
use FindBin;
use Scalar::Util;

sub html {
    my $self = shift;
    my $ret = ref $self;

    # Return based on self reference type
    given (Scalar::Util::reftype($self)) {
        when ("SCALAR") { $ret = $self->html_scalar() }
        when ("HASH") { $ret = $self->html_hash() }
    }

    return $ret;
}

sub html_scalar {
    my $self = shift;

    # New Textile and get rid of extra breaks, process scalar ref
    my $txtl = Text::Textile->new();
    $txtl->{_line_close} = "";

    return $txtl->process(${$self});
}

1;
