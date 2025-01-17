#!/bin/perl

# Given a list of files in bc-unix-dump.pl format, spit them out in a
# format useful for backups (stdin to stdout, no magic)

# Format of stdin fields:

# mtime (possibly with decimals)
# size
# inode
# file permission in octal
# file type (f for regular file, l for symlink, d for dir, etc)
# file group name or numeric id
# file username (owner) or numeric id
# file device number
# file name followed by null

require "/usr/local/lib/bclib.pl";

# write symlinks, dirs, and others to special files

open(A, ">links.txt")||die("Can't open links.txt, $!");
open(B, ">dirs.txt")||die("Can't open dirs.txt, $!");;
open(C, ">others.txt")||die("Can't open others.txt, $!");;

my($count);

while (<>) {

  my($time, $size, $inode, $perms, $type, $gid, $uid, $devno, $name,
  $path, $eol) = split(/\t/, $_);

  # if last field isn't EOL, warn and ignore

  unless ($eol eq "EOL") {
    warn("BAD LINE: $_");
    next;
  }

  # remove fractional part from mtime

  $time=~s/\..*//;

  # TODO: remove this hack after I switch to "+" by default

  $time=~s/ /+/;

  # for the most common case regular file, print mtime name and size

  if ($type eq "f") {
    print "$time $name\t$size\n";
    next;
  }

  die "ABANDONED";

  chomp;

  if (++$count%1000000==0) {debug("$count files");}

  # filename and tail now bracked by nulls

  unless (s/\0(.*?)\0(.*?)\0$//) {next;}

  my($name, $tail) = ($1, $2);

  my($mtime, $size, $inode, $perm, $type, $group, $user, $dev) = 
    split(/\s+/, $_);

  # we ignore everything that's not a real file, but it's not an error

  unless ($type eq "f") {next;}

  # floor (not round) the mtime and print the file and mtime
  # include nulls around filename so egrep and fgrep can work properly

  $mtime=~s/\..*//;

  # TODO: eventually want to include $tail below

  print "$name\0$tail\0$mtime\0$size\n";
}


