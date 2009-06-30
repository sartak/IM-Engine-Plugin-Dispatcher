package IM::Engine::Plugin::Dispatcher::AugmentsDispatcher;
use Moose::Role;
with 'IM::Engine::Plugin::Dispatcher::RequiresDispatcherPlugin';

requires 'new_rules';

sub augment_dispatcher {
    my $self = shift;
    my $args = shift;

    my $dispatcher = $args->{dispatcher};

    for my $rule ($self->new_rules) {
        $dispatcher->add_rule($rule);
    }
}

1;

