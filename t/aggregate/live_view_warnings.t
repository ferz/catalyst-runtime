#!perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;
use Catalyst::Test 'TestAppViewWarnings';

if ( $ENV{CATALYST_SERVER} ) {
    plan skip_all => 'Using remote server';
}

{
    ok( my $response = request('http://localhost/'), 'Request' );

# FIXME: does this warning really need to be like that?
    like($TestAppViewWarnings::log_messages[0], qr/Attempted to use view/s, 'View failure warning received');

}

done_testing;

