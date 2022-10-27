#!/usr/bin/env perl

use strict;
use FindBin;
use DateTime;
use DateTime::Duration;
use Getopt::Long;

my ( $days, $date );
GetOptions(
    "days:i" => \$days,
    "date:s" => \$date
);

if ( !( $days || $date ) ) {
    die <<EOF;
Usage: $FindBin::Script [--days n | --date d]
    --days n  if n<0, date n days ago; if n>0, date n days from now
    --date d  days between now and date d
EOF
}

my $right_now = DateTime->now( time_zone => "America/New_York" );
my $now       = DateTime->new(
    year      => $right_now->year,
    month     => $right_now->month,
    day       => $right_now->day,
    hour      => 0,
    minute    => 0,
    second    => 0,
    time_zone => "America/New_York"
);
my $fmt = "%8s : %s\n";
if ( defined $days ) {
    my $then = $now + DateTime::Duration->new( days => $days );
    &display( $now->ymd, $then->ymd, $days );
}
elsif ( defined $date ) {
    if ( $date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/ ) {
        my $then = DateTime->new(
            time_zone => "America/New_York",
            year      => $1,
            month     => $2,
            day       => $3,
            hour      => 0,
            minute    => 0,
            second    => 0
        );
        my $dur;
        my $delta_sec = $then->epoch - $now->epoch;
        my $is_past   = ( $delta_sec < 0 ? -1 : 1 );
        my $days      = sprintf( "%d", abs( $delta_sec / 3600 / 24 ) );
        &display( $now->ymd, $then->ymd, $days * $is_past );
    }
    else {
        die "Date format must be yyyy-MM-DD\n";
    }
}

sub display {
    my ( $now, $then, $duration ) = @_;
    printf $fmt, "Today", $now;
    printf $fmt, "Then",  $then;
    if ( $duration > 0 ) {
        $duration .= " days from now";
    }
    elsif ( $duration < 0 ) {
        $duration = abs($duration) . " days ago";
    }
    printf $fmt, "Duration", $duration;
}
