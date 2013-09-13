#!/bin/perl

# figure out which services are down (using montastic API + multiple
# accounts) and "report" these to ~/ERR which ultimately prints to my
# background image

# -nocurl: dont actually query montastic API (useful for testing)

push(@INC,"/usr/local/lib");
require "bclib.pl";

dodie('chdir("/var/tmp/montastic")');

system("rm -f commands.txt results.txt err.txt.new; touch err.txt.new");

# format of this file, each line is "username:password", # starts comments
for $i (split(/\n/,read_file("$ENV{HOME}/montastic.txt"))) {
  if ($i=~/^\#/ || $i=~/^\s*$/) {next;}
  ($user,$pass) = split(":",$i);
  append_file("echo $user; curl -s -H 'Accept: application/xml' -u $user:$pass https://www.montastic.com/checkpoints/index\n", "commands.txt");
  push(@users, $user);
}

unless ($globopts{nocurl}) {
  system("parallel -j 20 < commands.txt > results.txt");
}

# look at results
$all = read_file("results.txt");

while ($all=~s%<checkpoint>(.*?)</checkpoint>%%is) {
  $res = $1;

  # ignore turned off monitors
  if ($res=~m%<is-monitoring-enabled type="boolean">false</is-monitoring-enabled>%) {next;}

  # ignore good results
  if ($res=~m%<status type="integer">1</status>%) {next;}

  # offending URL
  $res=~m%<url>(.*?)</url>%isg;

  # write it to file
  append_file("$1\n","err.txt.new");
}

system("mv err.txt err.txt.old; mv err.txt.new err.txt");
