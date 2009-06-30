package IM::Engine::Plugin::404;
use Moose;
use Moose::Util::TypeConstraints;
extends 'IM::Engine::Plugin';
with 'IM::Engine::Plugin::ShortcutsDispatch';

sub shortcut_dispatch {
    my $self = shift;
    my $args = shift;

    return if $args->{dispatch}->has_matches;

    return "Unknown command.";
}

1;

