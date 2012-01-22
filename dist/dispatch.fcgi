#!/usr/bin/env perl

use FindBin;

use lib "$FindBin::Bin/env/lib/perl5", "$FindBin::Bin/lib";

use 5.010;
use strict;
use warnings;

use Plack::Handler::FCGI;
use Ohess;

