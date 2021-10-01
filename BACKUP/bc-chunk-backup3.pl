#!/bin/perl

# version 3 uses the format for afad-minus-egrep-fgrep-previous-backup.txt

# --checkfile: check that each file actually exists (slow)

require "/usr/local/lib/bclib.pl";
require "$bclib{home}/bc-private.pl";

# rewriting 27 Feb 2015 for a single file
# see README for file format

defaults("limit=25,000,000,000&xmessage=1");
$limit = $globopts{limit};

# lets me use commas
$limit =~s/,//g;

my($tot, $count);

open(A,">filelist.txt");
open(B,">statlist.txt");
open(C,">doesnotexist.txt");

while (<>) {
  chomp;

  my($orig) = $_;
  if (++$count%10000==0) {debug("COUNT: $count, BYTES: $tot");}
  if ($tot>=$limit) {last;}

  my($oname, $mtime, $name, $size) = split(/\0/, $_);

  # this slows things down a lot, but it useful when I've been making
  # changes to the fs
  if ($globopts{checkfile} && !(-f $name)) {
    print C "$name\n";
    warn("NOSUCHFILE: $name");
    next;
  }

  $tot+= $size;

  # TODO: if $size is small (indicating symlink or pointlessness,
  # don't add to this list) [256 = max length of filename and thus of
  # symlink?]

  # NOTE: to avoid problems w/ filesizes > $limit, we add to chunk
  # first and THEN check for overage
  print A "$name\n";
  print B "$size $mtime $name\n";
}

# can't assign and do "my" at same time, will be treated as list
my($ptime);
$ptime = localtime($mtime);

debug("Used $count files to meet total, earliest ts: $mtime ($ptime)");

# below is just to avoid "egrep: writing output: Broken pipe" errors
# TODO: is this the best way to handle those errors
# $count = 0;
# while (<>) {if (++$count%100000==0) {debug("IGNORE COUNT: $count");}}

close(A); close(B); close(C);

# TODO: restore this
# do this so we're not waiting on egrep
open(A,"|parallel -j 2");
print A "bc-total-bytes.pl statlist.txt | sort -nr >! big-by-dir.txt\n";
print A "sort -k1nr statlist.txt >! big-by-file.txt\n";
close(A);