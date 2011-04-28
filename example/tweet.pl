use strict;
use warnings;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use WebService::ShindanMaker;
use Net::Twitter::Lite;
use Config::Pit;
use utf8;
my ($tw, $ws);
my $id = shift @ARGV;

{ #prepare
  my $pit = pit_get('twitter.com', require => {
      consumer_key        => 'your consumer_key on twitter.com',
      consumer_secret     => 'your consumer_secret on twitter.com',
      access_token        => 'your access_token on twitter.com',
      access_token_secret => 'your access_token_secret on twitter.com',
    }
  );
  $tw = Net::Twitter::Lite->new(
    consumer_key    => $pit->{consumer_key},
    consumer_secret => $pit->{consumer_secret}
  );
  $tw->access_token($pit->{access_token});
  $tw->access_token_secret($pit->{access_token_secret});

  $ws = WebService::ShindanMaker->new(
    id   => $id,
    name => $tw->update_profile->{screen_name},
  );
}

{ # shindan and tweet
  my $result = $ws->run();
  my $status = $result->{result}. " ". $ws->{site_root}.$ws->{id};
  $tw->update( $status );
}


