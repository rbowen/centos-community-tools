#!/usr/bin/perl
use strict;
use warnings;

use LWP::Simple qw(get);
usage() unless $ARGV[0] && $ARGV[1];

# TODO use the current year, month, automatically.
my $year = $ARGV[0];
my $month = $ARGV[1];

usage() unless $year =~ m/\d\d\d\d/;

my $url = 'https://www.centos.org/minutes/' . $year . '/' . $month;
my $html = get $url;

my @html=split(/\n/, $html);
foreach my $line(@html) {

    # Looking for meeting minutes like centos-devel.2018-09-04-13.01.html
    next unless $line =~ m/centos-devel\.$year-\d\d-\d\d-\d\d\.\d\d\.html/;

    $line =~ s/^.+href="//;

    my ($filename, $date) = ( $line =~ m/^(.+?)".+?"right">(.+?) / );

    # On $date, there are meeting minutes in $filename. What SIG was that?
    my $minutesurl = $url . "/$filename";
    my $minutes = get $minutesurl;

    # print $minutes;
    my ($title) = ( $minutes =~ m!<h1>#centos-devel: (.*?)</h1>! );
    
    print "Meeting minutes from the $title, $date - $minutesurl  #CentOS #SIG\n";

}

sub usage {
    print "Usage: ./$0 YEAR MONTH - eg, ./$0 2018 September\n";
    exit();
}

