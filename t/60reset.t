#!perl

use strict;
use warnings;

use Test::More;
use Text::ScriptTemplate;

BEGIN { plan tests => 3 };

my $tmpl;

ok($tmpl = Text::ScriptTemplate->new);

my $condition = 1;

my $out = &test($condition);

cmp_ok( $out, 'eq', 'testing with condition', 'conditional include' );

undef $condition;

$out = &test($condition);

cmp_ok( $out, 'eq', 'testing', "no conditional include" );

sub test {
    my $condition = shift;
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
    chomp($fill);
    return $fill;
}

1;
