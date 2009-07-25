package IM::Engine::Plugin::Dispatcher::404;
use Moose;
extends 'IM::Engine::Plugin';
with 'IM::Engine::Plugin::Dispatcher::ShortcutsDispatch';

sub shortcut_dispatch {
    my $self = shift;
    my $args = shift;

    return if $args->{dispatch}->has_matches;

    return "Unknown command.";
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

