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
    my $stats;

    my $content = LWP::Simple::get($url);

    return undef
      unless(defined($content));
    
    return parse_meta(decode_json($content));
}

sub parse_meta {
    my $build = shift;
    my $stats;

    foreach my $step (@{$build->{steps}}) {
        if ($step->{name} eq "test") {
            $stats = sprintf(
              '<span>%s</span><span>%s</span>',
              $step->{'statistics'}->{'tests-failed'},
              $step->{'statistics'}->{'tests-passed'}
            );
        }
    }
    
    return $stats;
}

1;
