use inc::Module::Install;

name    'DBIx-Class-QueryLog';
all_from    'lib/DBIx/Class/QueryLog.pm';

requires    'Test::More';
requires    'Class::Accessor';
requires    'Moose' => '0.90';
requires    'Time::HiRes';
requires    'DBIx::Class'       => '0.07000';

auto_install;

WriteAll;
