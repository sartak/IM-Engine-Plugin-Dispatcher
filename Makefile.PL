use inc::Module::Install;

name     'IM-Engine-Plugin-Dispatcher';
all_from 'lib/IM/Engine/Plugin/Dispatcher.pm';
githubmeta;

requires 'IM::Engine' => 0.02;
requires 'Path::Dispatcher' => 0.12;

tests('t/*.t t/*/*.t');

auto_install;
WriteAll;

