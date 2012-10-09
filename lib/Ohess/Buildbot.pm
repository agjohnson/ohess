package Ohess::Buildbot;

use 5.010;
use strict;
use warnings;

use LWP::Simple qw//;
use JSON;

sub stats {
    my $project = shift;
    my $api = "http://build.ohess.org/json";
    my $url = sprintf("%s/builders/%s/builds/-1", $api, $project);

    my $content = LWP::Simple::get($url);

    return undef
      unless(defined($content));

    my $obj = decode_json($content);
    return undef
      unless(defined($obj));

    return parse_stats($obj);
}

sub parse_stats {
    my $obj = shift;
    my $stats;

    foreach my $step (@{$obj->{steps}}) {
        if ($step->{name} eq "test") {
            $stats = {
              failed => $step->{'statistics'}->{'tests-failed'},
              passed => $step->{'statistics'}->{'tests-passed'}
            };
        }
    }

    return $stats;
}

1;
