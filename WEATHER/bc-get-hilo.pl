#!/bin/perl

# Given the untar of the file ghcnd_all.tar.gz in
# ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/ (size ~2.9 GB), and the
# subsequent bzip2 compression of the dly files, this program computes
# the frequency of each temperature and stores it compactly; because
# there are many stations, time is of the esscence in the program

require "/usr/local/lib/bclib.pl";

# debug(percentile([1,2,7], [0,.15,.25,.5,.75,1]));

my($dir) = "/home/barrycarter/WEATHER/ghcnd_all";
chdir($dir)||die("Can't chdir");

# TODO: doing this in two batches (one for max temps and one for min
# temps) might be inefficient

# TODO: early versions might be not efficient (even more so than above)

for $i (glob "*.bz2") {

  my(%hash) = ();

  open(A,"bzegrep 'TMAX|TMIN' $i|");

  while (<A>) {

    my($orig) = $_;

    # figure out if its a max or min and kill off
    s/^.*(TMAX|TMIN)\s*//;
    my($key) = $1;

    # status codes are always letters, so this kills them off
    s/[a-z]//ig;

    # and the -9999
    s/\-9999//g;

    # and clean up leading spaces
    s/^\s*//;

    my(@vals) = split(/\s+/, $_);
    debug("VALS FOR $orig",@vals);
    push(@{$hash{$key}}, @vals);
    }

  my($stat) = $i;
  $stat=~s/\.dly\.bz2$//;
  my(@lows) = percentile($hash{TMIN}, [0,.01,.02,.05]);
  my(@highs) = percentile($hash{TMAX}, [.95,.98,.99,1]);
  print join(",",($stat,@lows,@highs)),"\n";
}


=item percentile(\@list, \@percentiles)

Calculate the given percentiles of a given a list.

TODO: maybe put this in bclib.pl

=cut

sub percentile {
  my($lref, $pref) = @_;
  my(@l) = sort(@$lref);
  my(@p) = @$pref;
  my(@ret);

  for $i (@p) {
    my($elt) = $#l*$i;
    my($int) = floor($elt);
    my($frac) = $elt-floor($elt);
    push(@ret, $l[$int]*(1-$frac) + $frac*$l[$int+1]);
  }
  return @ret;
}
