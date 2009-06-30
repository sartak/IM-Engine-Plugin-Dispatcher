package IM::Engine::Plugin::Dispatcher::ShortcutsDispatch;
use Moose::Role;
with 'IM::Engine::Plugin::Dispatcher::RequiresDispatcherPlugin';

requires 'shortcut_dispatch';

1;

