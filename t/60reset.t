#!perl

use strict;
use warnings;

use Test::More;
use Text::ScriptTemplate;

BEGIN { plan tests => 5 };

my $tmpl;

ok($tmpl = Text::ScriptTemplate->new);

my $condition = 1;
my $reset = 1;

my $out = &test($condition, $reset);

cmp_ok( $out, 'eq', 'testing with condition', 'conditional include' );

undef $condition;
$reset = 1;

$out = &test($condition, $reset);

cmp_ok( $out, 'eq', 'testing', "previous reset with no conditional include" );

$condition = 1;
undef $reset;

$out = &test($condition, $reset);

cmp_ok( $out, 'eq', 'testing with condition' ,"no conditional include with previous reset" );

undef $condition;

$out = &test($condition, $reset);

cmp_ok( $out, 'eq', 'testing with condition' ,"no conditional include no previous reset" );

sub test {
    my $condition = shift;
    my $reset = shift;
    my %data = ( 
      'foo' => {'value' => 'with condition'}
    ); 
    if ($condition) {
        $data{'conditional'} = 1;
    }
    my $tmpl = Text::ScriptTemplate->new;
    $tmpl->setq(%data);
    $tmpl->load('t/60reset.sub');
    my $fill =  $tmpl->fill;
    $tmpl->reset if $reset;
    chomp($fill);
    return $fill;
}

1;
