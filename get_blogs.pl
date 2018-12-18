#!/usr/bin/perl
use strict;
use warnings;

use XML::Feed;
use URI;
use XML::Simple;
use LWP::Simple;

$|++;

my $url = URI->new("http://planet.centos.org/atom.xml");

my $feed = XML::Feed->parse($url);

open (my $md, '>', 'blogs.md');
open (my $tweets, '>', 'blogs.tweets.csv');

foreach ( $feed->entries ) {

    print $md "**" 
            . $_->title . "** by " 
            . $_->author . "\n\n";
    my $body = $_->content->body;

    # Or possibly the summary?
    unless ( $body ) {
        $body = $_->summary->body;
        $body =~ s/\n.*//is
    }

    $body =~ s/^.*?<p[^>]*?>//i;
    $body =~ s!</p>.*$!!is;
    $body =~ s/<[^>]+>//igs; # Strip HTML
    $body =~ s/[\r\n]/  /gs; # Strip newlines from whatever's left
    print $md "> $body\n\n";

    my $link = $_->link;
    print $md "Read more at [$link]($link)\n\n\n";

    print $tweets '"01/01/2018 00:00:00","' . $_->title 
            . ' #OpenStack #RDOCommunity","'
            . $link . '"' . "\n";
}

close $md;
close $tweets;

print "\nDone\n";
