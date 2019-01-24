#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

use LWP::Simple qw(get);

use Getopt::Long qw(GetOptions);
my $help=0;
GetOptions("help" => \$help) or die "Usage: $0 -h for usage\n";
help() if $help;

# Start scheduling them today
my $dt = DateTime->now( time_zone => 'local' );
my $mday = $dt->day();
my $mon = $dt->month();

# Which month are we reporting on?
my $year = $ARGV[0] || $dt->year();
my $month = $ARGV[1] || $dt->month_name();

my $baseurl = 'https://lists.centos.org/pipermail/centos-announce/' .  $year . '-' . $month;
my $url = $baseurl . '/thread.html';
# print "*** $url *** \n";
my $html = get $url;

unless ($html) {
    print "It appears that there haven't been any announcements yet in the specified month.\n";
    exit();
}

open (my $tweets, '>', 'announce_tweets.csv' );
open (my $news, '>', 'announce_newsletter.txt' );
my (@ceea, @cesa, @ceba, @other);

my @html=split(/\n/, $html);
foreach my $line (@html) {

# Looking for lines like
# <LI><A HREF="023019.html">[CentOS-announce] CEEA-2018:2675 CentOS 6 microcode_ctl ...
# print "Considering $line\n";
    next unless $line =~ m/<LI><A HREF/;

    my ( $filename, $subject ) = ( $line =~ m/HREF="(.+?\.html).+? (.*)$/ );
    $subject =~ s/\s*Update$//;
    $subject =~ s/\s+/ /g;

    # We need a little information from that post
    my $email = get ( $baseurl . '/' . $filename );
    my ( $date ) = ( $email =~ m!<I>(.+?)</I>! );

    # The time isn't particularly important ...
    $date =~ s! \d\d:\d\d:\d\d ...!!;

    my $t = "On $date we issued the following update: $subject. Details at $baseurl/$filename #CentOS #Updates";
    print $t . "\n";
    print $tweets "\"$mon/$mday/$year 09:00\",\"$t\"\n";

    my $announce = "<li>$date: $subject - <a href=\"$baseurl/$filename\">$baseurl/$filename</a></li>";

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

sub help {
    print "Usage: $0 YEAR MONTH - eg, $0 2018 September\n";
    print "Defaults to current month of none specified.\n";
    exit();
}

