#!/bin/perl

# Determines which social media (facebook/twitter/google/linkedin)
# account I haven't downloaded for the longest time so I can keep
# downloads in rotation

# --showall: show latest backup for all accounts, even those less than
# 2 months old and those that are "archived"

# TODO: does NOT include creditkarma, creditsesame, nextdoor,
# stackexchange, or others

require "/usr/local/lib/bclib.pl";

my($out, $err, $res, %archive);

# the current time to avoid printing accts archived recently

my($now) = time();

# extra reminders for some sites

my(%extra) = (
 "facebook" => "(dl activity log + dta log)",
 "twitter" => "(update notifications)",
 "ifttt" => "new 3 app limitation"
);

# find all files in dirs where I backup stuff
# TODO: this is serious overkill, most aren't even backups

# TODO: amazon is the only one I haven't handled as of 10/24/2020

my(@dirs) = ("LINKEDIN", "TWITTER", "FACEBOOK", "GOOGLE", "INSTAGRAM", 
	     "DISCORD", "TUMBLR/BACKUPS", "DROPBOX", "IFTTT", 
	     "FREECODECAMP", "DOORDASH", "AMAZON", "YAHOO", "FETLIFE/BACKUPS");
my($dirspec) = join(" ",map($_ = "$bclib{home}/$_", @dirs));

# hash to keep latest save for each account
my(%latest);

# list of all my accounts; set time to "0" here just in case they've
# never been backed up (actually setting to "1" because stardate()
# treats 0 as "now"

($out, $err, $res) = cache_command2("egrep -v '^#' $bclib{home}/myaccounts.txt");

# list of errors to print at end so they are not lost
my(@errors);

for $i (split(/\n/, $out)) {

  # ignore blank lines
  if ($i=~/^\s*$/) {next;}

  # if the line has :ARCHIVE: I'm using Google's automated 2 month
  # archives-- set archive hash to indicate

  # remove the :ARCHIVE: code since we can still calculate latest stamp
  if ($i=~s/:ARCHIVE://) {$archive{$i} = 1;}

  # and comments
  if ($i=~s/:comment=([^:]*)//) {$comments{$i} = $1;}

  # some accounts specify their latest in the myaccount.txt file itself
  if ($i=~s/:latest=([^:]*)//) {$override{$i} = $1;}

  unless ($i=~m%^(.*?):(\S+)%) {push(@errors,"BAD LINE: $i"); next;}

  my($site, $acct) = ($1, $2);

  debug("SITEACCT: $site:$acct");

  $latest{lc("$site:$acct")} = 1;

  if ($override{$i}) {$latest{lc("$site:$acct")} = str2time($override{$i});}

}

debug("ARCHIVE", %archive);

# TODO: dont cache in production?
# NOTE: bc-*-zip.pl creates symlinks, thus "-type l"
# however, can also be files, so -o
# TODO: try to add -iname '*.zip' to this w/o breaking OR condition

($out, $err, $res) = cache_command2("find $dirspec -type l -o -type f", "age=0");

for $i (split(/\n/, $out)) {

  # specific to directory/site

  debug("FILE: $i");

  unless (
	  $i=~m%/(GOOGLE)/(.*?)\-(\d{8}T\d{6})Z.zip$% ||
	  $i=~m%/(LINKEDIN|TWITTER|FACEBOOK|DISCORD|TUMBLR/BACKUPS|YAHOO|FETLIFE/BACKUPS)/(.*?)\-(\d{8}\.\d{6})\.zip$% ||
	  $i=~m%/(INSTAGRAM)/(.*?)_(\d{8})\.zip$% ||
	  $i=~m%/(DROPBOX)/dropbox\-(.*?)\-(\d{8})\.zip$% ||
	  $i=~m%/(IFTTT|FREECODECAMP|DOORDASH)/(.*?)\-(\d{8})\.(json|zip)$%
	 ) {
    debug("IGNORING: $i");
    next;
  }

  my($site, $acct, $date) = (lc($1), lc($2), $3);

  # ignore raw forms of google and linkedin outputs
  if ($acct=~/^complete_linkedindataexport/ || $acct eq "takeout") {next;}

  # special case for tumblr and fetlife
  if ($site eq "tumblr/backups") {$site = "tumblr";}
  if ($site eq "fetlife/backups") {$site = "fetlife";}

  # convert "stardate" to form that makes str2time happy
  $date=~s/(\d{4})(\d{2})(\d{2})\.(\d{2})(\d{2})(\d{2})/$1-$2-$3 $4:$5:$6/;

  debug("DATE: $date");
  $date = str2time($date);

  debug("SAD: $site/$acct/$date");

  unless ($latest{"$site:$acct"} || $archive{"$site:$acct"}) {
    push(@errors,"$site:$acct not in ~/myaccounts.txt, possible error");
  }

  $latest{"$site:$acct"} = max($latest{"$site:$acct"}, $date);

  debug("SETTING LATEST $site:$acct TO ", $latest{"$site:$acct"});
}

for $i (sort {$latest{$b} <=> $latest{$a}} keys %latest) {

  # print extra reminders based on site (this is ugly)
  my($site) = $i;
  $site=~s/:.*$//;


  debug("I: $i, LATEST: $latest{$i}");

  # because $extra is local, don't really need else below

  my($extra) = "";
  if ($archive{$i}) {$extra .= "[ARCHIVE]";}
  if ($comments{$i}) {$extra .= "($comments{$i})";}

  # experimental
  if ($archive{$i} && !$globopts{showall}) {next;}

  # this is two months

#  if (($now - $latest{$i} < 365.2425/12*2*86400) && !$globopts{showall}){next;}

  warn("temporarily using 3 months");
  if (($now - $latest{$i} < 365.2425/12*3*86400) && !$globopts{showall}){next;}

  # 29 Jun 2021: want to change pws across the board + cleanup spacing

  my($line) = stardate($latest{$i}) . " $i $extra{$site} $extra (CHANGE PASSWORD)";
  $line=~s/\s+/ /g;
  print "$line\n";
}

for $i (@errors) {print "ERROR: $i\n";}

# debug(var_dump("latest",\%latest));

# TODO: remember to look at ~/myaccounts.txt for accounts that have
# perhaps never been backedup

=item comment

Sample file names AFTER I run bc-*-zip.pl:

LINKEDIN/linkedin@barrycarter.info-20180308.083352.zip 

TWITTER/barrycarter-20180225.151142.zip

FACEBOOK/barry.carter.121-20180127.080552.zip

GOOGLE/carter.barry@gmail.com-20180401T181753Z.zip

=cut
