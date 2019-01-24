#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

my %reporters = (
    1 => [
        'Core', 'Atomic', 'Config Management', 'PaaS', 'Software Collections',
    ],

    2 => [ 'Alt Arch', 'Cloud', 'NFV', 'Promo', 'Storage', ],

    3 => [
        'Artwork',  'Cloud Instance',
        'OpsTools', 'Public CI',
        'Virtualization',
      ]

);

# Who is reporting next month?
my $dt = DateTime->now( time_zone => 'local' )->add( months => 1 );

my $month = $dt->month_name;
print "Next month is $month.\n";

my $group = $dt->month() % 3;

print "We expect reports from SIGs in Group " . $group . ":\n\n";

foreach my $sig ( @{ $reporters{$group} } ) {
    print "  * $sig\n";
}

print "\n";

print "Send the following reminders to these SIGs\n";

foreach my $sig ( @{ $reporters{$group} } ) {

    print qq~
--------------------------------------------------

Dear $sig SIG,

As documented in the wiki, we request that each SIG reports quarterly
about the accomplishments of their SIG during the previous quarter.

As you may be aware, your SIG - the $sig SIG - is on the
list for $month reports. See "Reporting" section towards the bottom of
https://wiki.centos.org/SpecialInterestGroup

I encourage you to have a look at the report produced by the Cloud SIG
as an example of what we're looking for. It's not onerous - just an
overview of releases and community activity over the preceding few
months. https://blog.centos.org/2019/01/centos-cloud-sig-quarterly-report/

Reports can be submitted either directly to me, or, if you prefer, you
can submit it as a blog post on blog.centos.org

The report will be included in the $month community newsletter. As
such I need it by $month 1st, at the very latest.

Thanks!

~;

}
