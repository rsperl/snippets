#!/usr/bin/env python

# src: https://www.electricmonk.nl/log/2017/08/06/understanding-pythons-logging-module/

# check the logger and all its parents to cech the log level, name,
# and configured handlers

log_to_debug = logging.getLogger("myapp.ui.edit")
while log_to_debug is not None:
    print(
        "level: %s, name: %s, handlers: %s".format(
            log_to_debug.level, log_to_debug.name, log_to_debug.handlers
        )
    )
    log_to_debug = log_to_debug.parent

# output:
# level: 0, name: myapp.ui.edit, handlers: []
# level: 0, name: myapp.ui, handlers: []
# level: 0, name: myapp, handlers: []
# level: 30, name: root, handlers: []
#
# From this output it becomes obvious that all loggers use a level of 30,
# since their log levels are 0, which means the look up the hierarchy for
# the first logger with a non-zero level. I've also not configured any handlers.
# If I was seeing double output, it's probably because there is more than one
# handler configured.
