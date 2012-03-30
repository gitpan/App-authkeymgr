package App::authkeymgr;
our $VERSION = '0.010';

use 5.10.1;
use strict;
use warnings;

use Carp;

use File::Find;
use File::Spec;

sub findkeys {
  my ($keydir, $exts, $nodeep) = @_;
  
  croak "findkeys called with no keydir"
    unless defined $keydir;
  
  croak "findkeys called against non-directory $keydir"
    unless -d $keydir;
  
  $exts = [ qw/pub pubkey/ ]
    unless $exts and ref $exts eq 'ARRAY';

  my @found;  
  if ($nodeep) {
    opendir(my $dirh, $keydir) || croak "opendir failed: $!";
    while (my $maybekey = readdir($dirh)) {
      next if index($maybekey, '.') == 0;
      my $thisext = (split /\./, $maybekey)[-1] // next;
      push(@found, File::Spec->catfile($keydir, $maybekey))
        if $thisext ~~ @$exts;
    }
    closedir($dirh);
  } else {
    find(sub {
        my $thisext = (split /\./)[-1] // return;
        push(@found, $File::Find::name)
          if $thisext ~~ @$exts;
      },
      $keydir
    );
  }
    
  return @found
}


1;
__END__
=pod

=head1 NAME

App::authkeymgr - Interactively manage SSH authorized_keys files

=head1 SYNOPSIS

  ## Manage authorized_keys interactively
  $ authkeymgr --help
  
  ## Build authorized_keys out of self-managed dirs
  $ authkeys-rebuild --help

=head1 DESCRIPTION

B<authkeymgr> provides useful tools for managing C<authorized_keys> 
files.

With a long list of public keys, user management and revocation is 
significantly easier when dealing with discrete single pubkeys that 
live in a sensible directory structure.

The B<authkeymgr> shell makes it easy to add "users" (sets of 
public keys), add keys to users from external files, revoke/restore 
specific keys, and rebuild C<authorized_keys> after changes are made.
(See the perldoc for authkeymgr or use the I<help> command from the 
authkeymgr shell.)

For more flexibility, B<authkeys-rebuild> can be used for building 
C<authorized_keys> lists from self-managed directories.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

The original stand-alone authkeys-rebuild was the result of a bored 
Sunday and a discussion on B<#linode> @ I<irc.oftc.net> -- blame heckman.

=cut
