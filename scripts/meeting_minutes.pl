#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

use LWP::Simple qw(get);
use Getopt::Long qw(GetOptions);
my $help=0;
GetOptions("help" => \$help) or help();
help() if $help;

my $dt = DateTime->now( time_zone => 'local' );
my $year = $ARGV[0] || $dt->year();
my $month = $ARGV[1] || $dt->month_name();

my $url = 'https://www.centos.org/minutes/' . $year . '/' . $month;
my $html = get $url;

if ($html) {
my @html=split(/\n/, $html);
    foreach my $line(@html) {

        # Looking for meeting minutes like centos-meeting.2018-09-04-13.01.html
        next unless $line =~ m/centos-meeting\.$year-\d\d-\d\d-\d\d\.\d\d\.html/;

        $line =~ s/^.+href="//;

        my ($filename, $date) = ( $line =~ m/^(.+?)".+?"right">(.+?) / );

        # On $date, there are meeting minutes in $filename. What SIG was that?
        my $minutesurl = $url . "/$filename";
        my $minutes = get $minutesurl;

        # print $minutes;
        my ($title) = ( $minutes =~ m!<h1>#centos-meeting: (.*?)</h1>! );
        
        print "Meeting minutes from the $title, $date - $minutesurl  #CentOS #SIG\n";

    }
} else {
    print "There appear to be no meeting minutes for that month. See $url to confirm.\n";
}

sub help {
    print "Usage: ./$0 YEAR MONTH - eg, ./$0 2018 September\n";
    print "Defaults to current month of none specified.\n";
    exit();
}

