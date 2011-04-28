package WebService::ShindanMaker;

=head1 NAME

WebService::ShindanMaker - Shindanmaker client for perl.

=head1 SYNOPSIS

  use WebService::ShindanMaker;
  use YAML;
  my  $ws = WebService::ShindanMaker->new(
    {
      id   => 0000,
      name => q{YOUR_NAME},
    }
  );
  warn YAML::Dump $ws->info;
  my $result = $ws->run();
  warn $result;

=head1 DESCRIPTION

WebService::ShindanMaker is Shindanmaker client for perl.

=cut

use strict;
use warnings;
use WWW::Mechanize;
use Web::Scraper;
use Text::Trim;

=head1 Package::Global::Variable

=over

=item B<VERSION>

this package version.

=cut

our $VERSION = '1.00';

=back

=head1 CONSTRUCTOR AND STARTUP

=head2 new

Creates and returns a new WebService::ShindanMaker object.:

=cut

sub new {
  my $class = shift;
  my %args  = @_;
  $args{'agent'}      ||= __PACKAGE__." ".$VERSION;
  $args{'mech'}         = WWW::Mechanize->new(
      agent=> $args{'agent'},
  );

  $args{'site_root'}    = 'http://shindanmaker.com/';

  my $self = bless {%args}, $class;
  return $self;
}

=head1 METHODS

=head2 info

the information of the target Shindanmaker.:

$self->info( id => 1 );

診断メーカの概要を取得する。

=cut

sub info {
  my $self = shift;
  my %args = @_;

  my $validated = $self->_valid_info(
    {
      id => $args{id} || $self->{id}
    }
  );
  return unless $validated;
  $self->{id} = $validated->{id};

  my $data = $self->{mech}->get($self->{site_root}. $validated->{id});
  my $content = $data->decoded_content();

  my $info = $self->_perse_info($content);
  $info->{id}      = $validated->{id};
  $info->{content} = $content;

  return $info;
}

=head2 run

run the Shindanmaker.:

$self->run(
  id   => 1,
  name => 'your nick name'
);

診断メーカの結果を取得する。

=cut

sub run {
  my $self = shift;
  my %args = @_;

  my $validated = $self->_valid_run(
    {
      id   => $args{id}   ||  $self->{id},
      name => $args{name} || $self->{name},
    }
  );
  return unless $validated;
  $self->{id}   = $validated->{id};
  $self->{name} = $validated->{name};

  my $mech = $self->{mech};
  $mech->get($self->{site_root}. $validated->{id});
  $mech->field('u', $validated->{name});

  $mech->click();
  my $content = $mech->content();
  my $result = $self->_perse_run($content);

  $result->{id}      = $validated->{id};
  $result->{name}    = $validated->{name};
  $result->{content} = $content;
  return $result;
}


=head1 PRIVATE METHODS

=over

=item B<_parse_info>

診断メーカの情報パース

=cut

sub _perse_info {
  my $self = shift;

  my $content = shift;
  my $scraper = scraper
  {
    process '//div[@class="main4"]',
      'data' => scraper
    {
      process '//div[@class="shindantitle2"]/h1/a',
        subject     => 'TEXT';
      process '//div[@class="shindandescription"]/div[1]',
        description => 'HTML';
      process  '//div[@class="shindandescription"]/div[2]/b[1]',
        users       => 'TEXT';
      process  '//div[@class="shindandescription"]/div[2]/b[2]',
        pattern     => 'TEXT';
    };
    result 'data';
  };
  my $result = $scraper->scrape($content);
  $result = { Text::Trim::trim(%$result) };
  return $result;
}


=item B<_parse_run>

診断メーカー実行結果パース

=cut

sub _perse_run {
  my $self = shift;
  my $content = shift;
  my $scraper = scraper
  {
    process '//div[@class="main4"]',
      'data' => scraper
    {
      process '//div[@class="shindantitle2"]/h1/a',
        subject     => 'TEXT';
      process '//div[@class="shindandescription"]/div[1]',
        description => 'HTML';
      process  '//div[@class="shindandescription"]/div[2]/b[1]',
        users       => 'TEXT';
      process  '//div[@class="shindandescription"]/div[2]/b[2]',
        pattern     => 'TEXT';
      process  '//div[@class="result"]/div',
        result     => 'TEXT';
    };
    result 'data';
  };
  my $result = $scraper->scrape($content);
  $result = { Text::Trim::trim(%$result) };
  return $result;
}


=item B<_valid_info>

診断メーカの情報取得に必要なvalidate

=cut
sub _valid_info {
  my $self = shift;
  my $valid = shift;
  die 'required id' if not exists $valid->{id} or !$valid->{id};
  return $valid;
}

=item B<_valid_info>

診断メーカー実行に必要なvalidate

=cut

sub _valid_run {
  my $self = shift;
  my $valid = shift;
  die 'required id.' if not exists $valid->{id}   or !$valid->{id};
  die 'required name.' if not exists $valid->{name} or !$valid->{name};
  return $valid;
}


=back

=cut

1;

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO
L<http://shindanmaker.com/>,
WWW::Mechnize,
Web::Scraper,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
