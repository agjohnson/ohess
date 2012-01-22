use Test::More tests => 6;

BEGIN {
    use_ok('Avocado');
    use_ok('Text::Textile');
    use_ok('LWP::Simple');
    use_ok('JSON');
}

BEGIN {
    use_ok('Plack');
    use_ok('Plack::Handler::FCGI');
}
