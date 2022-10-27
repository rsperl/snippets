#!/usr/bin/env perl

#
# Example Usage
#
# use lib ".";
# use sas3w;
#
# if( is_third_weekend_day ) {
#  print "It's third weekend\n";
# } else {
#   print "It's not third weekend\n";
# }
#

use strict;
use POSIX qw(strftime);

sub get_third_weekend_dates {
    my ( $year, $month ) = @_;
    my $weekday = strftime( "%u", 0, 0, 0, 1, $month - 1, $year - 1900 ) - 1;
    return 20, 21 if $weekday == 0;    # Mon
    return 19, 20 if $weekday == 1;    # Tue
    return 18, 19 if $weekday == 2;    # Wed
    return 17, 18 if $weekday == 3;    # Thu
    return 16, 17 if $weekday == 4;    # Fri
    return 15, 16 if $weekday == 5;    # Sat
    return 21, 22 if $weekday == 6;    # Sun
}

sub is_third_weekend_day {
    my @parts = localtime(time);
    my $year  = $parts[5] + 1900;
    my $month = $parts[4] + 1;
    my $day   = $parts[3];
    my ( $sat, $sun ) = get_third_weekend_dates( $year, $month );
    return 1 if $day == $sat || $day == $sun;
    return 0;
}
1;
