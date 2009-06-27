use inc::Module::Install;

name     'IM-Engine-Plugin-Dispatcher';
all_from 'lib/IM/Engine/Plugin/Dispatcher.pm';

requires 'IM::Engine';
requires 'Path::Dispatcher';

tests('t/*.t t/*/*.t');

auto_install;
WriteAll;

