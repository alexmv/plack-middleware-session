#!/usr/bin/perl

use strict;
use warnings;
use File::Spec;

use Test::More;

use Plack::Request;
use Plack::Session;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;

use t::lib::TestSession;

my $TMP = File::Spec->catdir('t', 'tmp');

t::lib::TestSession::run_all_tests(
    store           => Plack::Session::Store::File->new( dir => $TMP ),
    state           => Plack::Session::State->new,
    request_creator => sub {
        open my $in, '<', \do { my $d };
        my $env = {
            'psgi.version'    => [ 1, 0 ],
            'psgi.input'      => $in,
            'psgi.errors'     => *STDERR,
            'psgi.url_scheme' => 'http',
            SERVER_PORT       => 80,
            REQUEST_METHOD    => 'GET',
        };
        my $r = Plack::Request->new( $env );
        $r->parameters( @_ );
        $r;
    },
);

unlink $_ foreach glob( File::Spec->catdir($TMP, '*') );

done_testing;