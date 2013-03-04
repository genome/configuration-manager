use strict;
use warnings;

package ConfigurationManager;
use YAML::Syck;

sub AUTOLOAD {
    my $self = shift;
    #if we're at the root, we don't have an instance yet, so make one
    unless (ref $self && $self->isa('ConfigurationManager')){
        $self = ConfigurationManager->_new(@_);
    }
    #grab method and strip package name off
    my $method_name = our $AUTOLOAD;
    $method_name =~ s/.*:://;

    if(!$self->{is_file}){
        my $current_location = $self->{location};
        my $new_location = join('/', $current_location, $method_name);

        if(-e $new_location){
            $self->_navigate_directory($new_location);
        }elsif(-e (my $filename = $new_location . '.yml')){
            $self->_read_file($filename);
        }else{
            die("Expected to find a file or directory at $new_location!");
        }
    }else{
        $self->_get_property($method_name);
    }
}

sub _navigate_directory {
    my ($self, $new_location) = @_;
    die("Expected a directory named $new_location but found a file!") unless -d $new_location;
    return ConfigurationManager->_new($new_location);
}

sub _read_file {
    my ($self, $file_name) = @_;
    my $properties = LoadFile($file_name);
    return ConfigurationManager->_new($file_name, 1, $properties);
}

sub _get_property {
    my ($self, $property_name) = @_;
    die("Expected to find a key named $property_name") unless exists $self->{properties}{$property_name};
    my $property = $self->{properties}{$property_name};
    if(ref $property eq 'HASH'){
        return ConfigurationManager->_new($self->{location}
            . "{$property_name}", 1, $property);
    }else {
        return $property;
    }
}

sub _new {
    my $class = shift;
    my $location = shift || $ConfigurationManager::default_basedir;
    my $is_file = shift;
    my $properties = shift;
    bless {
            location => $location,
            is_file => $is_file,
            properties => $properties,
          }, $class;
}

sub DESTROY { 1; }

$ConfigurationManager::default_basedir = 'config';
sub import {
    shift;
    my $basedir = shift;
    $ConfigurationManager::default_basedir = $basedir if $basedir;
}


1;