package Ohess::Main;

use 5.010;
use strict;
use warnings;

use Avocado;

# Default page
get '.*' => sub { 
    return abort(404); 
};

# Error 404 handler
error 404 => sub {
    return template("error.tt", { error => 404 });
};

1;
