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

has has_augmented_dispatcher => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

sub BUILD {
    my $self = shift;
    if ($self->engine->interface->has_incoming_callback) {
        confess "When using " . __PACKAGE__ . ", do not specify an incoming_callback";
    }

    $self->engine->interface->incoming_callback(
        sub { $self->incoming(@_) },
    );
}

sub incoming {
    my $self     = shift;
    my $incoming = shift;

    unless ($self->has_augmented_dispatcher) {
        $self->has_augmented_dispatcher(1);
        $self->engine->each_plugin(
            role       => 'Dispatcher::AugmentsDispatcher',
            method     => 'augment_dispatcher',
            dispatcher => $self->dispatcher,
        );
    }

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

    my $dispatch = $dispatcher->dispatch($incoming->plaintext);

    $self->engine->plugin_relay(
        role              => 'Dispatcher::ChangesDispatch',
        method            => 'change_dispatch',
        baton             => $dispatch,
        incoming          => $incoming,
        original_dispatch => $dispatch,
    );

    my $message = $self->engine->plugin_default(
        role     => 'Dispatcher::ShortcutsDispatch',
        method   => 'shortcut_dispatch',
        incoming => $incoming,
        dispatch => $dispatch,
    );

    return $message if $message;

    return $dispatch->run($incoming, @_);
}

__PACKAGE__->meta->make_immutable;
no Moose;
no Moose::Util::TypeConstraints;

1;

