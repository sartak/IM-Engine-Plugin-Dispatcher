package IM::Engine::Plugin::ShortcutsDispatch;
use Moose::Role;
with 'IM::Engine::Plugin::RequiresDispatcherPlugin';

requires 'shortcut_dispatch';

1;

