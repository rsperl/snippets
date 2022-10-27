#!/usr/bin/env perl

use Try::Tiny

      # determine which package to use
      my $pkg = "My::Package";

# call require (runtime) instead of use (compile-time)
try {
    require $pkg;
    $pkg->import;
}
catch {
    $err = $_;
};
die("can't require $file: $err") if $err;

# gather your args
my @obj_args = ( name => "richard", msg => "hello" );
my $obj      = $pkg->new(@obj_args);

# use $obj as normal...
