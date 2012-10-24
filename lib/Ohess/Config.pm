package Ohess::Config;

use 5.010;
use strict;
use warnings;

use YAML qw//;
use File::stat;
use FindBin;

use Ohess::Textile;

my $pub_config = sprintf("%s/%s", $FindBin::Bin, "pubs.yaml");
my $page_config = sprintf("%s/%s", $FindBin::Bin, "pages.yaml");

sub pubs {
    return undef unless(-r $pub_config);
    
    local $YAML::SortKeys = 0;
    my $pubs = YAML::LoadFile($pub_config);
    
    return $pubs;
}

sub pub {
    my $id = shift;
    my $pubs = pubs();

    return $pubs->{$id}
      if (defined $pubs->{$id});
    
    return undef;
}

sub pages {
    return undef unless(-r $page_config);

    local $YAML::SortKeys = 0;
    my $pages = YAML::LoadFile($page_config);
    
    return $pages;
}

sub page {
    my $id = shift;
    my $pages = pages();

    return $pages->{$id}
      if (defined $pages->{$id});
    
    return undef;
}

1;
