#!/usr/bin/env python
# -*- coding: utf-8 -*-

# with help from https://gist.github.com/miketaylr/5969656

import sys

try:
    from LaunchServices import (
        LSSetDefaultHandlerForURLScheme,
        LSCopyDefaultHandlerForURLScheme,
    )
except:
    sys.exit(
        "to run this script, first run 'pip install pyobjc-framework-LaunchServices'"
    )

supported_browser_ids = {
    "chrome": "com.google.chrome",
    "firefox": "org.mozilla.firefox",
    "safari": "com.apple.Safari",
}
supported_browsers = supported_browser_ids.keys()

try:
    browser = sys.argv[1]
    browser_id = supported_browser_ids[browser]
except:
    sys.exit("Usage: {} <{}>".format(sys.argv[0], "|".join(supported_browsers)))


url_schemes = ["http", "https"]


# kLSRolesViewer
# see https://developer.apple.com/library/mac/#documentation/Carbon/Reference/LaunchServicesReference/Reference/reference.html#//apple_ref/c/tdef/LSRolesMask
rolesViewer = 0x00000002

is_updated = False
for scheme in url_schemes:
    current_handler = LSCopyDefaultHandlerForURLScheme(scheme)
    if current_handler != browser_id:
        is_updated = True
        LSSetDefaultHandlerForURLScheme(scheme, browser_id)

if is_updated:
    print(
        "Click 'Use {}' to set the default browser to {}".format(
            browser.title(), browser
        )
    )
else:
    print("{} is already the default browser".format(browser))
