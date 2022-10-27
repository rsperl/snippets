#!/usr/bin/env perl

use strict;
use Log::Log4perl qw(get_logger);

my $log_config = <<EOF;
log4perl.rootLogger = TRACE, Test
log4perl.appender.Test = Log::Log4perl::Appender::File
log4perl.appender.Test.filename = logfile.json
log4perl.appender.Test.layout = Log::Log4perl::Layout::JSON


# Specify which fields to include in the JSON hash:
# (using PatternLayout placeholders)

log4perl.appender.Test.layout.field.message = %m
log4perl.appender.Test.layout.field.category = %c
log4perl.appender.Test.layout.field.class = %C
log4perl.appender.Test.layout.field.file = %F{1}
log4perl.appender.Test.layout.field.sub = %M{1}

log4perl.appender.Test.layout.prefix = \@cee:

EOF

Log::Log4perl::init( \$log_config );

my $log = get_logger();

$log->info("test log");
$log->debug("boo hoo");
