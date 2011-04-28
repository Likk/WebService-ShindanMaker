use inc::Module::Install;
name 'WebService-ShindanMaker';
all_from 'lib/WebService/ShindanMaker.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
