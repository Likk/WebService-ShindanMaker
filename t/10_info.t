use strict;
use Test::More;
use WebService::ShindanMaker;
use utf8;

{
  my $ws;
  subtest 'prepare' => sub {
    $ws = WebService::ShindanMaker->new();
    isa_ok($ws, 'WebService::ShindanMaker', 'can new');

    done_testing();
  };

  subtest 'info' => sub {
    my $info = $ws->info(id => 113926);

      ok $info->{content},                                              'content';
      is $info->{id},          113926,                                  'id check';
      is $info->{subject},     'WebService::Shindanmaker',              'subject check';
      is $info->{description}, 'WebService::Shindanmaker テスト用です', 'description check';
      like $info->{users},   qr/\d+/,                                   'runners check';
      is $info->{pattern},     1,                                       'pattern check';

    done_testing();
  };

  done_testing();
}
