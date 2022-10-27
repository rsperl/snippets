#!/usr/bin/env perl

use strict;
use Log::Log4perl qw(get_logger);
use Data::Dumper;
use Data::Printer;

my $log_config = q{
# log4perl.category = TRACE, DB
 log4perl.logger = TRACE, DB
 log4perl.appender.DB             = Log::Log4perl::Appender::DBI
 log4perl.appender.DB.datasource  = dbi:SQLite:dbname=logfile.db
 log4perl.appender.DB.sql         = \
    insert into entries           \
    (timestamp, level, pid, userid, ip, package, line, message) \
    values (?, ?, ?, ?, ?, ?, ?, ?)

 # timestamp
 log4perl.appender.DB.params.1 = %d

 # level
 log4perl.appender.DB.params.2 = %p

 # pid
 log4perl.appender.DB.params.3 = %P

 # userid
 log4perl.appender.DB.params.4 = %X{userid}

 # ip
 log4perl.appender.DB.params.5 = %X{ip}

 # package
 log4perl.appender.DB.params.6 = %C

 # line number
 log4perl.appender.DB.params.7 = %L

 # message
 log4perl.appender.DB.params.8 = %m

 log4perl.appender.DB.usePreparedStmt = 1

 #just pass through the array of message items in the log statement
 log4perl.appender.DB.layout    = Log::Log4perl::Layout::NoopLayout

# log4perl.appender.DB.warp_message = 0

 #driver attributes support
 log4perl.appender.DB.attrs.f_encoding = utf8
};

Log::Log4perl::init( \$log_config );

my $log = get_logger();

Log::Log4perl::MDC->put( "userid", "myusername" );
Log::Log4perl::MDC->put( "ip",     "127.0.0.1" );
$log->info("boo hoo");
$log->trace("wank");
$log->debug("what just happened?");
$log->fatal("g'night folks");

my $d = {
    a => 1,
    b => 2,
    c => [qw(1 2 3 4 5)]
};

$log->trace( "data: " . Dumper($d) );
$log->trace( "data: " . p($d) );
