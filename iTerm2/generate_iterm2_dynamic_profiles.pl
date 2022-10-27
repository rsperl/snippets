#!/usr/bin/env perl

#
# licensed under GPL v2, same as iTerm2 https://www.iterm2.com/license.txt
#

use strict;
use JSON;

my $output = $ENV{HOME} . "/Library/Application\ Support/iTerm2/DynamicProfiles/profiles.json";
print STDERR "profiles will be written to '$output'\n";

my @profiles;
my $ssh_config = $ENV{HOME} . "/.ssh/config";
open my $fh, '<', $ssh_config;
my @contents = <$fh>;
close $fh;

my $name;
my $custom_command;
my @tags;
for ( my $i = 0; $i < @contents; $i++ ) {
    my $line = $contents[$i];
    chomp $line;
    next if index( $line, '*' ) >= 0;
    if ( $line =~ /^Host\s+(.+?)$/ ) {
        my $match = $1;
        if ( $match =~ /(.+?)\s+#\s+Tags=(.+?)$/ ) {
            $name = $1;
            @tags = split( /\s*,\s*/, $2 );
        }
        else {
            $name = $match;
            @tags = ();
        }
    }
    elsif ( $line =~ /^\s*$/ ) {
        next unless $name;
        print STDERR "adding profile for $name\n";
        $custom_command = "ssh $name";
        my $p = {
            Name             => $name,
            Guid             => $name,
            Shortcut         => "",
            "Custom Command" => "Yes",
            Command          => $custom_command,
        };
        $p->{Tags}      = [@tags] if (@tags);
        $name           = "";
        $custom_command = "";
        @tags           = ();
        push( @profiles, $p );
    }
}

my $json = to_json( { Profiles => \@profiles }, { pretty => 1 } );
open my $fh, '>', $output;
print $fh $json;
close $fh;
print STDERR "finished\n";
