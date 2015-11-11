#!/bin/perl

# parses mmmc.gnumeric into meetup API format

# date formats:

# MTRF1100-1300: weekdays, start time to (optional) end time
# 20151117:1000-1100: "stardate", start time to (optional) end time
# 13F1145-1330: first and third Friday, start time to (optional) end time

# TODO: publish on icalshare, craigslist as well (for this reason, I
# compute the dates myself and don't use icalendar or meetup.com's
# recurring event features)

# TODO: check existing events to avoid overwrite

# TODO: announce meetups if/when I have an actual group

# TODO: limit events to 15m alignment IF meetup.com can't handle
# otherwise (they allow millisecond timing, but don't actually appear
# to support it)

require "/usr/local/lib/bclib.pl";
require "/home/barrycarter/bc-private.pl";

# TODO: change gname when not testing
my($gname,$status) = ("Meetup-API-Testing", "published");
# my ($gname,$status) = ("Albuquerque-Multigenerational-Center-Events-unofficial","draft");

my($desc) = "

This event was copied directly from an Albuquerque area
multigenerational center event. For more information on this event and
Albuquerque's multigenerational centers, please contact:

https://www.cabq.gov/seniors/centers/north-domingo-baca-multigenerational-center (offical site for North Domingo Baca Multigenerational Center)

https://www.cabq.gov/seniors/centers/manzano-mesa-multigenerational-center (official site for Manzano Mesa Multigenerational Center)

http://manzanomesacenter.com/ (unofficial site for Manzano Mesa Multigenerational Center)

The owner of this meetup group is not affiliated with the City of
Albuquerque, and has no further information on this event, sorry.

Although this event is listed in an official City of Albuquerque
publication or website, there is no guarantee that it will actually
occur. Please contact the venue directly if you need to be sure.

You do need to RSVP for this event to attend; however, you may RSVP if
you choose to do so.

";

# convert weekdays to number
for $i (0..6) {$wday{substr("xmtwrfs",$i,1)} = $i;}
# convert spreadsheet to array
my(@arr) = gnumeric2array("$bclib{githome}/CALENDAR/mmmc.gnumeric");
# the first row is headers
my(@headers) = @{$arr[0]};

debug("HEADERS",@headers);

# remaining rows are events

for $i (1..$#arr) {

  # create hash
  my(%hash) = ();
  for $j (0..$#headers) {$hash{lc($headers[$j])} = $arr[$i][$j];}

  $hash{name} = urlencode($hash{name});

  for $j (split(/\n/,$hash{when})) {
    my(@dates) = parseDateString($j,11,2015);

    for $k (@dates) {
      my($st,$en) = @{$k};

      # now, cruft the meetup itself

      # the description will always contain $desc above, but may have more
      my($edesc);

      if ($hash{cost}) {$edesc .= "Cost: $hash{cost}\n\n";}
      if ($hash{location}) {$edesc .= "Location: $hash{location}\n\n";}
      if ($hash{contact}) {$edesc .= "Contact: $hash{contacts}\n\n";}
      if ($hash{comments}) {$edesc .= "Comments: $hash{comments}\n\n";}

      $edesc .= $desc;
      $edesc=~s/\n\n/<br><br>\n/sg;
      $edesc = urlencode($edesc);

      my($pstr) = "time=".$st*1000;

      if ($en) {$pstr.="&duration=".($en-$st)*1000;}

      # TODO: venue id currently hardcoded to MMMC, allow this to
      # change when I add NDBC (North Domingo Baca Center)

      # these are fixed for all meetups I post
      # TODO: using draft for now
      $pstr .= "&group_urlname=$gname&key=$private{meetup}{key}&guest_limit=999&publish_status=$status&venue_visibility=public&venue_id=710375";

      # TODO: add non-fixed data to post: name, description
      $pstr .= "&name=$hash{name}&description=$edesc";

      # for now, just print the command, don't actually run it
      print "curl -d '$pstr' 'https://api.meetup.com/2/event'\n";
    }
  }
}

# TODO: catch cases where I say "TH" to mean "R" (Thursday)

# given one of the date formats above, return a list of Unix time
# pairs of start and end times (with end time being optional), for a
# given month and year

sub parseDateString {

  my($str,$mon,$yr) = @_;
  my($stime,$etime,@res);

  # handle "stardate" format
  if ($str=~s/^(\d{8}):(.*)$//) {
    my($sdate,$time) = ($1,$2);
    ($stime,$etime) = split(/\-/,$time);
    # ok to overwrite here, not going thru loop below
    $stime = str2time("$sdate $stime MST7MDT");
    $etime = $etime?str2time("$sdate $etime MST7MDT"):"";
    # this is a one-element list whose element is a list of two elements
    return [$stime,$etime];
  }

  # need 2 digit months for matching
  $mon = sprintf("%02d",$mon);

  my(@which,@wdays);

  # TODO: ignoring special case of fixed stardate for now
  # numeric specifier (if any) pre weekday list
  # if no specifier "first 6" of month which is all (+ overkill on 6?)
  if ($str=~s/^([\d]+)//) {@which = split(//,$1)} else {@which=(1,2,3,4,5,6);}

  # now the weekdays
  if ($str=~s/^([xmtwrfs]+)//i) {
    @wdays=split(//,$1);
    # map dates to numbers
    map($_=$wday{lc($_)},@wdays);
  }

  # what's leftover is start and end time (end might be empty)
  my($stime,$etime) = split(/\-/,$str);

  # and loop
  for $i (@which) {
    for $j (@wdays) {

      # compute "stardate" of this event
      my($sdate) = weekdayAfterDate("$yr${mon}01",$j,$i-1);

      # ignore dates not in current month
      unless ($sdate=~/^$yr$mon/) {next;}

      # TODO: figure out what to do w/ no start time
      unless ($stime) {warn "NO STIME ($str), IGNORING"; next;}
      # unix start and end times
      my($ustime) = str2time("$sdate $stime MST7MDT");
      my($uetime) = $etime?str2time("$sdate $etime MST7MDT"):"";
      push(@res,[$ustime,$uetime]);
    }
  }
  return @res;
}

# TODO: move this to bclib.pl at some point

sub weekdayAfterDate {
  my($date,$day,$n) = @_;
  my($time) = str2time("$date 12:00:00 UTC");
  # the -3 makes Monday = 1
  my($wday) = ($time/86400-3)%7;
  # add appropriate amount for first weekday after date
  $time += ($day-$wday)%7*86400 + $n*86400*7;
  return strftime("%Y%m%d", gmtime($time));
}




