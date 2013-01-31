use strict;
use warnings;

use Test::More;

use_ok('ConfigurationManager', 'loaded configuration manager module');

#directory
my $config = ConfigurationManager->models(__FILE__ . '.d' );
isa_ok($config, 'ConfigurationManager', 'we got one!');

#directory that doesn't exist
eval {
    ConfigurationManager->blah(__FILE__ . '.d' );
};
my $error = $@;
ok($error, "should throw an error when trying to navigate somewhere that doesn't exist");


#file nested in dir
$config = ConfigurationManager->models(__FILE__ . '.d' )->people;
isa_ok($config, 'ConfigurationManager', 'we got one!');

#hash inside file
$config = ConfigurationManager->models(__FILE__ . '.d' )->people->bob;
isa_ok($config, 'ConfigurationManager', 'we got one!');

#direct property inside file
my $franks_val = ConfigurationManager->models(__FILE__ . '.d' )->people->frank;
is($franks_val, 'has no properties', 'access a property in a file');

#properties inside hash in file
$config = ConfigurationManager->models(__FILE__ . '.d' )->people->bob;
is('bobs profile', $config->profile);
is('bobs build', $config->build);
is('turkey', $config->favorite_sandwich);

#nonexistent key
eval {
    $config->blah;
};
$error = $@;
ok($error, "getting a key that doesn't exist throws an exception");


done_testing();
