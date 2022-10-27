#!/usr/bin/env perl
BEGIN {

    # alias all references to the package to A
    *A:: = \*ThisIsAVeryLongPackageName::;
}

package ThisIsAVeryLongPackageName;

sub spam {
    print "spam from ThisIsAVeryLongPackageName - __PACKAGE__=" . __PACKAGE__ . "\n";
}
1;

package main;

# we can now use the aliased package name
A::spam();

1;
