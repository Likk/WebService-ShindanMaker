use strict;
use Test::More;
use Test::Exception;
use WebService::ShindanMaker;
use utf8;

{
  my $ws;

  subtest 'prepare' => sub {
    $ws = WebService::ShindanMaker->new(
    );
    isa_ok($ws, 'WebService::ShindanMaker', 'can new');

    done_testing();
  };

  subtest 'info' => sub {
    throws_ok { my $info = $ws->info } qr/required id/, 'info -id validate ok';

    done_testing();
  };

  subtest 'run' => sub {
    throws_ok { my $result = $ws->run }               qr /required id/,   'run -id  validate ok';
    throws_ok { my $result = $ws->run( id=>113926 ) } qr /required name/, 'run -name validate ok';

    done_testing();
  };

  done_testing();
}
