package IM::Engine::Plugin::Dispatcher;
use Moose;
extends 'IM::Engine::Plugin';

has dispatcher => (
    is       => 'ro',
    isa      => 'ClassName',
    required => 1,
);

1;

