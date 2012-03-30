use strict; use warnings;
use Module::Build;

my $build = Module::Build->new(
  module_name   => 'App::authkeymgr',
  dist_abstract => 'Interactively manage SSH authorized_keys files',
  dist_author   => 'Jon Portnoy <avenj@cobaltirc.org>',
  license       => 'perl',
  
  create_makefile_pl => 'small',
  create_readme => 1,

  configure_requires => {
      'Module::Build' => '0.38',
  },

  build_requires => {
    'Test::More'    => 0,
  },
  
  requires => {
    'perl' => '5.10.1',
   # Core:
    'File::Copy'   => 0,
    'File::Find'   => 0,
    'File::Path'   => '2.06',
    'File::Spec'   => 0,
    'Getopt::Long' => 0,
    'Time::Piece'  => 0,
    'Text::ParseWords' => 0,
    
    'File::Slurp' => '9999.14',
    
    'Term::UI'       => '0.20',
    'Term::ReadLine' => 0,
  },
);

$build->create_build_script;
