#!/bin/perl

# Trivial script to create tiles for Dink that simply tell you what
# tile you are on

require "/usr/local/lib/bclib.pl";

# working dir
dodie('chdir("/mnt/extdrive/FREEDINK/20150627/tiles/")');

for $tile ("01".."511") {
  open(A,"|fly -q|convert gif:- ts$tile.bmp");
  print A << "MARK";
new
size 600,400
setpixel 0,0,255,192,192
MARK
;
  for $y (1..8) {
    for $x (1..12) {
      my($px,$py) = ($x*50-40,$y*50-25);
      print A "string 0,0,0,$px,",$py-10,",small,t=$tile\n";
      print A "string 0,0,0,$px,",$py,",small,x=$x\n";
      print A "string 0,0,0,$px,",$py+10,",small,y=$y\n";
    }
  }
}
