#!/usr/bin/perl
use strict;
use warnings;

use LWP::Simple qw(get);
usage() unless $ARGV[0] && $ARGV[1];

# TODO use the current year, month, automatically.
my $year = $ARGV[0];
my $month = $ARGV[1];

usage() unless $year =~ m/\d\d\d\d/;

my $baseurl = 'https://lists.centos.org/pipermail/centos-announce/' .  $year . '-' . $month;
my $url = $baseurl . '/thread.html';
# print "*** $url *** \n";
my $html = get $url;

unless ($html) {
    print "It appears that there haven't been any announcements yet in the specified month.\n";
    exit();
}

open (my $tweets, '>', 'announce_tweets.txt' );
open (my $news, '>', 'announce_newsletter.txt' );
my (@ceea, @cesa, @ceba, @other);

my @html=split(/\n/, $html);
foreach my $line (@html) {

# Looking for lines like
# <LI><A HREF="023019.html">[CentOS-announce] CEEA-2018:2675 CentOS 6 microcode_ctl ...
# print "Considering $line\n";
    next unless $line =~ m/<LI><A HREF/;
# print "PASSED\n";

    my ( $filename, $subject ) = ( $line =~ m/HREF="(.+?\.html).+? (.*)$/ );
    $subject =~ s/\s*Update$//;
    $subject =~ s/\s+/ /g;

    # We need a little information from that post
    my $email = get ( $baseurl . '/' . $filename );
    my ( $date ) = ( $email =~ m!<I>(.+?)</I>! );

    # First line after <!--beginarticle-->\n<PRE>\n ...
#    my ( $title ) = ( $email =~ m~<!--beginarticle-->\n<PRE>\n(.+?)\n~);

    # Some messages are ... different
#    unless ($title) {
#        print "\nThis message wasn't formatted like we expected. See message titled \"$subject\" for more details.\n";
#
#        print "Best effort:\n";
#        print "$subject. Details at $baseurl/$filename #CentOS #Updates\n";
#        next;
#    }

#    $title =~ s/\s*$//;
#    $title =~ s/\s*/ /g;

    my $t = "On $date we issued the following update: $subject. Details at $baseurl/$filename #CentOS #Updates";
    print $t . "\n";
    print $tweets "\"01/01/$year 09:00:00\",\"$t\"\n";

    my $announce = "<li>$subject - <a href=\"$baseurl/$filename\">$baseurl/$filename</a></li>";

    push (@cesa, $announce) if $subject =~ m/CESA/;
    push (@ceea, $announce) if $subject =~ m/CEEA/;
    push (@ceba, $announce) if $subject =~ m/CEBA/;
    push (@other, $announce) unless $subject =~ m/CE.A/;
}

errata( $month, $news, 'Enhancements', 'CEEA', @ceea );
errata( $month, $news, 'Security', 'CESA', @cesa );
errata( $month, $news, 'Bugfix', 'CEBA', @ceba );
errata( $month, $news, 'Other', 'Other', @other);

sub errata {
    my ( $month, $news, $name, $acro, @arry ) = @_;

    if ($name eq 'Other') {
        print $news qq~\n\n<h3>Other releases</h3>

The following releases also happened during $month:

~;
    } else {
        print $news qq~\n\n<h3>Errata and $name Advisories</h3>

We issued the following $acro (CentOS Errata and $name Advisories) during $month:

~;
    }

    print $news "<ul>\n";

    foreach my $i (@arry) {
        print $news "    $i\n";
    }

    print $news "</ul>\n\n";

}

sub usage {
    print "Usage: $0 YEAR MONTH - eg, $0 2018 September\n";
    exit();
}

