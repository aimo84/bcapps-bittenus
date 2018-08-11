#!/bin/perl

# attempt to see how fast fly/perl can create a large image; I've
# always assumed it's prohibitively slow to use Perl/fly to create
# large images, but maybe not

require "/usr/local/lib/bclib.pl";

# now lets try the "real" map, coastline distance

# lowest inland value is -2513.32
# highest shore value is 2694.96

# middle of ocean = deep blue, shore = light blue

# middle of land = deep red, shore = light red

# 255,0,0 to 255,128,128 are the 128+1 land colors
# 0,0,255 to 128,128,255 are the 128+1 water colors

# .04 degree, so 360/.04 and 180/.04 for size

print "new\nsize 9000,4500\n";

my($x,$y) = (0,0,0);

while (<>) {

  my($lon, $lat, $dist) = split(/\s+/, $_);
  # h will be the value of the opposing colors
  my($h);

  # determine color
  if ($dist < 0) {
    $h = ceil(127-127*$dist/-2513.32);
    print "setpixel $x,$y,255,$h,$h\n";
  } else {
    $h = floor(127*$dist/2694.96);
    print "setpixel $x,$y,$h,$h,255\n";
  }

  # counting here may be faster than computing from lat/lon each time
  if (++$x == 9000) {$x=0; $y++;}
}

die "TESTING";

# 255 random colors to start with!

my(@colors);

for $i (1..256) {
  push(@colors, join(",",floor(rand()*255), floor(rand()*255), floor(rand()*255)));
}

print "new\nsize 4096,4096\n";


for $i (0..4095) {
  for $j (0..4095) {
    my($c) = $colors[floor(rand()*256)];
    print "setpixel $i,$j,$c\n";
  }
}

# with 16384^2 random points, takes 6:32.27 (6.5m)

# with 4096^2, takes 0:23.14

# so roughly prop to #dots

# on 4096^2, fly -q itself takes: 0:17.60 [but image fails, too many colors!]

# with fixed random colors, 4096^2 takes 0:06.45

# fly takes 0:12.67
