#
# because there are more than 1500 values for the member attribute, you have to get the paged
# results. The attribute will be named member;range=x-y unless it's the remainder, in which
# case it will be member;range=x-*. If you search beyond the last result, no entries will be
# returned
#
my @current_member_dns;

# define the maximum number of members we will look for
my @member_attrs = qw(
      member;range=0-1499
      member;range=1500-2999
      member;range=3000-4499
      member;range=4500-5999
);

# loop through those possible member values, but check to see which one you
# actually received back.
foreach my $attr (@member_attrs) {
    my $opts = { base => $group_parent_dn, filter => "($cn)", attrs => [$attr] };
    $log->info("...searching with attribute $attr");
    my @group_entries = SAS::AD::get_entries( $ad, $opts );
    if ( !@group_entries ) {
        $log->logconfess("unable to find $dlp_group_dn with base=$group_parent_dn, filter=$cn, and attrs=$attr");
        exit;
    }
    if ( @group_entries > 1 ) {
        $log->logconfess("expected to find a single entry for filter=$cn and base=$group_parent_dn but found multiple");
        exit;
    }
    my $group_entry = shift @group_entries;

    #
    # if this is the last of the results (member;range=x-*), then the attribute you
    # searched for won't be the same as you get back. For instance, if there are 1800
    # results, then you would be looking for member;range=1500-*, not the current
    # attribute of member;range=1500-2999. If this is the last set of values, set a
    # flag to quit searching.
    #
    my $found_all_members = 0;
    foreach my $a ( $group_entry->attributes ) {
        if ( $a =~ /^member/ ) {
            $log->info("...getting values for attribute $a");
            push @current_member_dns, $group_entry->get_value($a);
            $found_all_members = 1 if $a =~ /^member;range=\d+\-\*$/;
        }
    }
    last if $found_all_members;
}
$log->trace( "current_member_dns: " . Dumper( \@current_member_dns ) );
