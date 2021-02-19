#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

my %reporters = (
    1 => [
        'Core', 'Config Management',
        'PaaS', 'Software Collections',
        'Hyperscale',
    ],

    2 => [ 'Alt Arch', 'Cloud', 'NFV', 'Promo', 'Storage', 'Messaging', ],

    3 => [
        'Artwork',        'Cloud Instance',
        'OpsTools',       'Public CI',
        'Virtualization', 'Infrastructure',
    ]

);

my @sigs;

# Who is reporting next month?
# my $dt = DateTime->now( time_zone => 'local' )->add( months => 1 );
my $dt = DateTime->now( time_zone => 'local' );

my $month = $dt->month_name;
print "Next month is $month.\n";

my $group = ( ($dt->month() % 3) || 3 );

print "We expect reports from SIGs in Group " . $group . ":\n\n";

foreach my $sig ( @{ $reporters{$group} } ) {
    print "  * $sig\n";
    push @sigs, $sig;
}

print "\n";

print "Send the following reminders to these SIGs\n";

foreach my $sig ( @{ $reporters{$group} } ) {

    print qq~
--------------------------------------------------

SUBJECT: CentOS $sig SIG quarterly report for $month newsletter

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
can submit it as a blog post on blog.centos.org.

See https://wiki.centos.org/SpecialInterestGroup/Promo/Blog for details
about posting to the CentOS blog.

The report will be included in the $month community newsletter. As
such I need it by $month 1st, at the very latest.

Thanks!

~;

}

print "Summary: reports expected from\n";
foreach my $sig (@sigs) {
    print "  * $sig\n";
}
