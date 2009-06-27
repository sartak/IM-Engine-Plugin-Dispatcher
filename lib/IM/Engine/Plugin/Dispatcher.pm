package IM::Engine::Plugin::Dispatcher;
use Moose;
use Moose::Util::TypeConstraints;
extends 'IM::Engine::Plugin';

subtype 'IM::Engine::Plugin::Dispatcher::Dispatcher'
     => as 'Path::Dispatcher';

coerce 'IM::Engine::Plugin::Dispatcher::Dispatcher'
    => from 'Str'
    => via {
        my $class = $_;
        Class::MOP::load_class($class);

        # A subclass of Path::Dispatcher
        if ($class->can('new')) {
            return $class->new;
        }
        # A sybclass of Path::Dispatcher::Declarative
        else {
            return $class->dispatcher;
        }

        # would be nice to improve this...
    };

has dispatcher => (
    is       => 'ro',
    isa      => 'IM::Engine::Plugin::Dispatcher::Dispatcher',
    coerce   => 1,
    required => 1,
);

1;

