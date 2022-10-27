#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json


class SshConfigParser(object):

    entries = []

    default_ssh_config = os.getenv("HOME") + "/.ssh/config"
    default_iterm_profiles = (
        os.getenv("HOME")
        + "/Library/Application Support/iTerm2/DynamicProfiles/profiles.json"
    )

    def __init__(self, configfile=default_ssh_config):
        self.configfile = configfile

    def parse(self):
        host = False
        aliases = []
        options = dict()

        with open(self.configfile, "r") as f:
            for line in f:
                line = line.strip()

                if line == "" or line[0] == "#":
                    continue

                if line[0:4].lower() == "host":
                    if host:
                        self.entries.append(
                            dict(host=host, aliases=aliases, options=options)
                        )
                        host = False
                        aliases = []
                        options = dict()
                    parts = line.split(" ")
                    host = parts[1]
                    aliases = parts[2:]
                    continue

                parts = line.split(" ")
                options[parts[0].lower()] = " ".join(parts[1:])
        return self.entries

    def list_entries(self, reparse=False):
        if not self.entries or reparse:
            self.entries = self.parse()
        return self.entries

    def generate_iterm2_profiles(self):
        profiles = []
        for e in self.list_entries():
            if not e["host"]:
                continue

            if e["host"].find("*") >= 0:
                continue

            realhost = e["host"]
            print("adding host: {}".format(e["host"]))
            if "options" in e and "hostname" in e["options"]:
                realhost = e["options"]["hostname"]

            cc = "ssh " + realhost
            if "proxycommand" in e["options"]:
                cc = e["options"]["proxycommand"]
            p = {
                "Name": e["host"],
                "Guid": e["host"],
                "Shortcut": "",
                "Custom Command": "Yes",
                "Command": cc,
                "Tags": e["aliases"],
            }
            profiles.append(p)
        return profiles

    def sshconfig2iterm2(self, profilefile=default_iterm_profiles):
        profiles = self.generate_iterm2_profiles()
        with open(profilefile, "w") as f:
            f.write(json.dumps(dict(Profiles=profiles), indent=2))


if __name__ == "__main__":
    s = SshConfigParser()
    s.sshconfig2iterm2()
