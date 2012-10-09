use Test::More tests => 4;

BEGIN {
    use_ok('Text::Textile');
    use_ok('LWP::Simple');
    use_ok('JSON');
}

BEGIN {
    use_ok('Plack');
}
