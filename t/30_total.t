use strict;
use Test::More;
use WebService::ShindanMaker;
use utf8;

{
  my $ws;

  subtest 'prepare' => sub {
    $ws = WebService::ShindanMaker->new(
      id   => 113926,
      name => q{user_name},
    );
    isa_ok($ws, 'WebService::ShindanMaker', 'can new');

    done_testing();
  };

  subtest 'info' => sub {
    my $info = $ws->info;

    ok $info->{content},                                              'content';
    is $info->{id},          113926,                                  'id check';
    is $info->{subject},     'WebService::Shindanmaker',              'subject check';
    is $info->{description}, 'WebService::Shindanmaker テスト用です', 'description check';
    like $info->{users},   qr/\d+/,                                   'runners check';
    is $info->{pattern},     1,                                       'pattern check';

    done_testing();
  };

  subtest 'run' => sub {
    my $result = $ws->run;

    ok   $result->{content},'content';
    is   $result->{id},          113926,                                  'id check';
    is   $result->{name},        'user_name',                             'name check';
    is   $result->{subject},     'WebService::Shindanmaker',              'subject check';
    is   $result->{description}, 'WebService::Shindanmaker テスト用です', 'description check';
    like $result->{users},       qr/\d+/,                                 'runners check';
    is   $result->{pattern},     1,                                       'pattern check';
    is   $result->{result},      'これはテストです。',                    'result check';

    done_testing();
  };

  done_testing();
}
