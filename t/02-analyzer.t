#!perl -T

use strict;
use warnings;
use Test::More tests => 14;

BEGIN {
    use_ok('DBIx::Class::QueryLog');
    use_ok('DBIx::Class::QueryLog::Analyzer');
}
require_ok('DBIx::Class::QueryLog::Analyzer');

my $ql = DBIx::Class::QueryLog->new;
ok($ql->isa('DBIx::Class::QueryLog'), 'new');

$ql->query_start('SELECT * from foo');
$ql->query_end('SELECT * from foo');
ok(scalar(@{ $ql->log }) == 1, 'log count w/1 query');

$ql->txn_begin;
$ql->query_start('SELECT * from foo');
$ql->query_end('SELECT * from foo');

$ql->query_start('SELECT * from bar');
sleep(1);
$ql->query_end('SELECT * from bar');

$ql->txn_commit;

my $ana = DBIx::Class::QueryLog::Analyzer->new({
    querylog => $ql
});
isa_ok($ana, 'DBIx::Class::QueryLog::Analyzer');
isa_ok($ana->querylog, 'DBIx::Class::QueryLog');

cmp_ok(scalar(@{ $ana->get_sorted_queries }), '==', 3, 'Sorted Count');

my $analyzed = $ana->get_totaled_queries;
my @keys = reverse sort {
        $analyzed->{$a}->{'time_elapsed'} <=> $analyzed->{$b}->{'time_elapsed'}
    } keys(%{ $ana->get_totaled_queries });
cmp_ok(scalar(@keys), '==', 2, '2 different queries');

cmp_ok($analyzed->{$keys[0]}->{'count'}, '==', 1, '1 executions');

cmp_ok($analyzed->{$keys[1]}->{'count'}, '==', 2, '2 executions');

ok($analyzed->{$keys[0]}->{'time_elapsed'}, 'Total time');
cmp_ok(scalar(@{$analyzed->{$keys[0]}->{'queries'}}), '==', 1, '1 stored queries');
cmp_ok(scalar(@{$analyzed->{$keys[1]}->{'queries'}}), '==', 2, '2 stored queries');