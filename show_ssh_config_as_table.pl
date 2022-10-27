#!/usr/bin/env perl

use strict;
use Data::Dumper;

my $action = shift @ARGV || "ls";

sub usage {
    print "Usage: $0 ls <entry>\n";
    exit 1;
}

my $configfile = $ENV{HOME} . "/.ssh/config";
die "Can't find config file $configfile\n" unless -f $configfile;

my $data = parse_config($configfile);

my $fn = "cmd_$action";
$fn =~ s/\-/_/g;
if ( __PACKAGE__->can($fn) ) {
    my $ref = \&{$fn};
    &$ref;
}
else {
    die("invalid action '$action' (maybe you need to add function $fn)\n");
}

sub cmd_ls {
    my $e = shift @ARGV;
    if ($e) {
        die "no such entry '$e'\n" unless $data->{$e};
        if ( $data->{$e} ) {
            print ">>> $e\n";
            foreach my $n ( sort keys %{ $data->{$e} } ) {
                my $v = $data->{$e}->{$n};
                if ( ref($v) eq 'ARRAY' ) {
                    $v = join( ", ", @$v );
                }
                printf "  %8s : %s\n", $n, $v;
            }
            exit 1;
        }
    }
    my $fmt     = "%30s : %10s : %30s : %s\n";
    my $headers = sprintf( $fmt, qw(Alias User Host:Port Tags) );
    print $headers;
    my $l = length($headers) + 20;
    print "-" x $l . "\n";
    foreach my $entry ( sort keys %$data ) {
        my $i = $data->{$entry};

        #print Dumper($i);
        my $h .= $i->{HostName} || "";
        $h .= ":$i->{Port}" if $i->{Port};
        my $tags = "";
        if ( $i->{tags} && @{ $i->{tags} } ) {
            $tags = join( ', ', @{ $i->{tags} } );
        }
        printf $fmt, $entry, $i->{User}, $h, $tags;
    }
}

sub parse_config {
    my $config = shift;
    my $data   = {};
    open my $fh, '<', $config or die "can't open $config for reading: $!";
    my $chost = "";
    while ( my $line = <$fh> ) {
        next if $line =~ /^$/;
        if ( $line =~ /^Host ([a-z0-9\-\.]+)\s*#?\s*(Tags=)?(.+)?$/i ) {
            $data->{$chost}->{User} = $ENV{USER} unless $data->{$chost};
            $chost = $1;
            my @tags = split( /\s*,\s*/, $3 );
            $data->{$chost} = { tags => \@tags };
            next;
        }
        if ( $line =~ /^\s+(\w+)\s+(.+)$/ ) {
            $data->{$chost}->{$1} = $2;
            next;
        }
    }
    close $fh;
    return $data;
}
