#!/bin/perl

# Create HTML (and perhaps text?) pages from a "meta media wiki
# definition file" (pbs.txt); this is sort of specific for files that
# have date followed by data or "MULTIREF" followed by data

# TODO: create captions of actual images for feh

# TODO: don't rely on ("date info") or ("MULTIREF info") in source file

require "/usr/local/lib/bclib.pl";

my($data, $fname) = cmdfile();

# to store all triples
my(%triples);

create_semantic_triples();

sub create_semantic_triples {

    # read the data and limit to the <data></data> section
    my($all) = read_file($fname);
    $all=~m%<data>(.*?)</data>%s;
    
    my($pages) = $1;

    # go through each line of data
    for $i (split(/\n/, $pages)) {

	# find leftmost word (which is date or dates)
	$i=~s/^(\S+)\s+//;
	my($dates) = $1;

	# TODO: don't ignore MULTIREF
	if ($dates eq "MULTIREF") {
	    warn("IGNORING MULTIREF");
	    next;
	}

	# keep parsing until no double brackets are left (nothing in while loop)
	while ($i=~s/\[\[([^\[\]]*?)\]\]/parse_triple($dates,$1)/e) {}
    }
}

=item parse_triple($source, $string)

Given a $source of data (like "2020-03-17") and a string like
"[[x::y]]" (with several variants), add to global list of semantic
triples and return a string. This function is called "inside out", so
$string will never have double brackets

Plus signs like [[x+y::...]] are treated like [[x::...]], [[y::...]]
and add to global list of triples and returns (TODO: what to return)

Details:

[[x]] - return LINK(x)

[[x::y]] - add $triples{$source}{x}{y} and $triples{y}{"-x"}{$source} and
return string LINK(y)

[[x::y|z]] - add $triples{$source}{x}{y} and $triples{y}{"-x"}{$source} and
return string LINK(y,z)

[[x::y::z]] - adds $triples{x}{y}{z} and $triples{z}{"-y"}{x} and
returns LINK(z)

TODO: this currently adds to GLOBAL hash

=cut

sub parse_triple {

    my($source, $string) = @_;

    my(@parts) = split(/::/, $string);

    # if just one part, return as above
    if ($#parts == 0) {
	# TODO: what if x has plus signs in it
	return "LINK($parts[0])";
    }

    # list of sources if $source is a range
    my(@sources) = parse_date_list($source);

    if ($#parts == 1) {

	my($linktext);

	if ($parts[1]=~s/\|(.*)//) {$linktext=$1;}

	for $i (@sources) {
	    $triples{$source}{$parts[0]}{$parts[1]} = 1;
	    $triples{$parts[1]}{"-$parts[0]"}{$source} = 1;
	}

	if ($linktext) {return "LINK($parts[1],$linktext";}
	return "LINK($parts[1])";
    }




    debug("TRIPLE: $string");

}