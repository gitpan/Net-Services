use strict;
use Test::More tests => 1;
my $pkg = 'Net::Services';

# Test documentation
use Pod::Coverage;
my $pc = Pod::Coverage->new(package => $pkg);
my $c = $pc->coverage;
if (defined $c and $c == 1)
{
    pass "POD Coverage Good";
}
else
{
    fail "POD Coverage inadequate: ".$pc->naked;
}


