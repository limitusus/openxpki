# OpenXPKI::Client::HTML::Mason::ApacheHandler
# Written 2006 by Martin Bartosch and Alexander Klink for the OpenXPKI project
# (C) Copyright 2006 by The OpenXPKI Project

package OpenXPKI::Client::HTML::Mason::ApacheHandler;

use strict;

use HTML::Mason::ApacheHandler;
eval { require Apache::Request } or { require Apache2::Request };

my %ah;

sub handler {
    my $r = shift;   # Apache request object

    my $host   = $r->hostname();
    if (! exists $ah{$host}) {
        # create persistent handler object for this particular host 
        make_apache_handler($r);
    }
    return $ah{$host}->handle_request($r);
}

sub make_apache_handler {
    my $r      = shift;
    my $host   = $r->hostname();

    my %p = HTML::Mason::ApacheHandler->_get_mason_params($r);
    $p{comp_root} = $p{comp_root}[0];

    my $ah = HTML::Mason::ApacheHandler->new(
        %p,
        'default_escape_flags' => 'h', # protect against XSS atacks
    );

    $ah{$host} = $ah;

    return 1;
}

1;
