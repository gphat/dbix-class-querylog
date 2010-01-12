#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DBIx::Class::QueryLog' );
}

diag( "Testing DBIx::Class::QueryLog $DBIx::Class::QueryLog::VERSION, Perl $], $^X" );
