use strict;
use warnings;

use Test::More;

use ExtUtils::Packlist;
use File::Temp qw( tempfile );

my $packlist = ExtUtils::Packlist->new();

my $evil_path = "/some/evil\npath";
my $packfile  = tempfile;

$packlist->{$evil_path} = { type => 'file' };
my $error;
eval {
    $packlist->write($packfile);
} or $error= $@;
like($error,qr/Sorry/,"Got expected error");

if (0) {
    # in theory we should be able to pass this test,
    # in practice we die. I am leaving this here as a reminder.
    my $new_packlist = ExtUtils::Packlist->new($packfile);

    ok( exists $packlist->{$evil_path},
        "Original path found in packlist before writing" )
      or diag explain $packlist;

    ok( exists $new_packlist->{$evil_path},
        "Original path found in packlist after reading" )
      or diag explain $new_packlist;
}

done_testing;
