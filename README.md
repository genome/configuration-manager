##Configuration Manager

---


Given a root directory containing potentially nested configuration files (in yaml format) the ConfigurationManager module will allow for programatic access to the underlying values.
The package will lazily load values as requested.

The root path defaults to a directory called config/ at the root of your project. You can point to a different configuration directory in your use statement.

###Usage

---
Given a directory structure:

        config/
            |
            | models/
                |
                | people.yml


And a YAML file (people.yml):

        frank: has no properties
        bob:
          profile: bobs profile
          build: bobs build
          favorite_sandwich: turkey
        fred:
          profile: freds profile
          build: freds build
          favorite_sandwich: roast beef


You can do the following:

        my $config = ConfigurationManager->models->people
        => ConfigurationManager
        $config->frank
        => 'has no properties'
        $config->bob
        => ConfigurationManager
        $config->bob->build
        => 'bobs build'

###Tests

---
        perl -I lib/ t/ConfigurationManager.t
