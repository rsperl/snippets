use Data::Dumper;

sub AUTOLOAD {
    my ($self) = @_;

    our $AUTOLOAD;    # so "use strict" is happy
                      # Get the last part of what was called
                      # (i.e., This::That::my_var, $1 set to "my_var")
    print("AUTOLOAD: AUTOLOAD=$AUTOLOAD\n");
    print( "AUTOLOAD: \@_='" . Dumper( \@_ ) . "\n" );
    if ( $AUTOLOAD =~ /.*::(.*)/ ) {
        my $element = $1;

        # Can even create an sub in symbol table for next time:
        *$AUTOLOAD = sub { print "$element was called without going through AUTOLOAD: " . Dumper( \@_ ) . "\n"; };
        print("AUTOLOAD: creating method '$element'\n");
        *$AUTOLOAD->( "[first time called]", @_ );

    }
}

hello( "blah", "world" );
hello("second time called");
