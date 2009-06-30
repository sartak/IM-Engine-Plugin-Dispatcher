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

sub BUILD {
    my $self = shift;
    if ($self->engine->interface->has_incoming_callback) {
        confess "When using " . __PACKAGE__ . ", do not specify an incoming_callback";
    }

    $self->engine->interface->incoming_callback(
        sub { $self->incoming(@_) },
    );

    $self->engine->each_plugin(
        role       => 'AugmentsDispatcher',
        method     => 'augment_dispatcher',
        dispatcher => $self->dispatcher,
    );
}

sub incoming {
    my $self     = shift;
    my $incoming = shift;

    my $message = $self->dispatch($incoming, @_);
    return $message if blessed $message;

    return if !defined($message);

    return $incoming->reply(
        message => $message,
    );
}

sub dispatch {
    my $self       = shift;
    my $incoming   = shift;
    my $dispatcher = $self->dispatcher;

    my $dispatch = $dispatcher->dispatch($incoming->message);

    $self->engine->plugin_relay(
        role              => 'ChangesDispatch',
        method            => 'change_dispatch',
        baton             => $dispatch,
        incoming          => $incoming,
        original_dispatch => $dispatch,
    );

    my $message = $self->engine->plugin_default(
        role     => 'ShortcutsDispatch',
        method   => 'shortcut_dispatch',
        incoming => $incoming,
        dispatch => $dispatch,
    );

    return $message if $message;

    return $dispatch->run($incoming, @_);
}

1;

