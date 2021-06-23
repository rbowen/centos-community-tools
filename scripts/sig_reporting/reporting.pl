#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

my %reporters = (
    1 => [
        [ 'Core',                 'sig-core@centosproject.org' ],
        [ 'Config Management',    'sig-configmanagement@centosproject.org' ],
        [ 'Software Collections', 'sig-sclo@centosproject.org' ],
        [ 'Hyperscale',           'sig-hyperscale@centosproject.org' ],
    ],

    2 => [
        [ 'Alt Arch',  'sig-altarch@centosproject.org' ],
        [ 'Cloud',     'sig-cloud@centosproject.org' ],
        [ 'NFV',       'sig-nfv@centosproject.org' ],
        [ 'Promo',     'centos-promo@centos.org' ],
        [ 'Storage',   'sig-storage@centosproject.org' ],
        [ 'Messaging', 'sig-messaging@centosproject.org' ],
    ],

    3 => [
        [ 'Artwork',        'sig-artwork@centosproject.org' ],
        [ 'Cloud Instance', 'sig-cloudinstance@centosproject.org' ],
        [ 'OpsTools',       'sig-opstools@centosproject.org' ],
        [ 'Public CI',      'ENOSIG' ],
        [ 'Virtualization', 'sig-virt@centosproject.org' ],
        [ 'Infrastructure', 'sig-infra@centosproject.org' ],
    ]

);

my @sigs;

# Who is reporting next month?
# Weirdly, just doing month+1 can sometimes skip past a shorter month.
# eg, March 31 + 1 month puts you in May, not April.
my $today = DateTime->now( time_zone => 'local' );
my $dt =
  DateTime->new( day   => 1, 
                 month => $today->month(), 
                 year  => $today->year() ) -> add( months => 1 );

my $month = $dt->month_name;
print "Next month is $month.\n";

my $group = ( ( $dt->month() % 3 ) || 3 );

print "We expect reports from SIGs in Group " . $group . ":\n\n";

foreach my $sig ( @{ $reporters{$group} } ) {
    print "  * $sig->[0]\n";
    push @sigs, $sig->[0];
}

print "\n";

print "Send the following reminders to these SIGs\n";

foreach my $sig ( @{ $reporters{$group} } ) {
    my $name  = $sig->[0];
    my $email = $sig->[1];

    print qq~
--------------------------------------------------

SUBJECT: CentOS $name SIG quarterly report for $month newsletter
To: $email

Dear $name SIG,

As documented in the wiki, we request that each SIG reports quarterly
about the accomplishments of their SIG during the previous quarter.

(You are receiving this because you are listed in the $name
SIG ACL on accounts.centos.org. If that is not accurate, you should take
it up with your SIG lead. See https://accounts.centos.org/groups/)

As you may be aware, your SIG - the $name SIG - is on the
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
