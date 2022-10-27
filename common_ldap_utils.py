#!/usr/bin/env python3

import yaml
import logging
import ldap
from ldap.controls import SimplePagedResultsControl
from pprint import pprint as pp
import sys
import ldap.modlist as modlist
from datetime import datetime

DEFAULT_PAGE_SIZE = 10


def filetime2datetime(filetime: int) -> datetime:
    """
    convert ldap windows filetime to epoch and timestamp
    """
    filetime = int(sys.argv[1])
    seconds_till_epoch = 11644473600
    epoch = filetime / 10000000 - seconds_till_epoch
    return datetime.fromtimestamp(epoch)


def rootdse(c):
    # based on https://www.programcreek.com/python/example/107948/ldap3.Connection
    criteria = "(objectClass=*)"
    attributes = ["*"]
    try:
        c.search(
            search_base="",
            search_filter=criteria,
            search_scope=BASE,
            dereference_aliases=DEREF_NEVER,
            attributes=attributes,
            time_limit=10,
        )
    except LDAPOperationResult as e:
        if isinstance(e.message, dict) and "desc" in e.message:
            raise Exception(e.message["desc"])
        else:
            raise Exception(e)

    if len(c.entries) == 0:
        return None
    elif len(c.entries) == 1:
        dse = c.response[0]["raw_attributes"]["rootDomainNamingContext"][0]
        return dse.decode()
    else:
        raise Exception(
            "Aborting - more than one DN found for rootdse - Found {1} - {2}".format(
                len(c.entries), c.entries
            )
        )


def get_entries(con, base=False, ldapfilter=False, attrlist=["*"], scope=False):
    if not con:
        raise ValueError("a connection must be given")
    print("get_entries - bound as " + str(con.whoami_s()))
    if not base:
        base = get_connection_base(con)
    print("base: " + base)
    if not ldapfilter:
        raise ValueError("an ldapfilter must be given")
    if not scope:
        scope = ldap.SCOPE_SUBTREE
    print("looking up %s" % ldapfilter)

    lc = ldap.controls.SimplePagedResultsControl(
        True, size=DEFAULT_PAGE_SIZE, cookie=""
    )
    entries = []
    while True:
        # Send search request
        try:
            # If you leave out the ATTRLIST it'll return all attributes
            # which you have permissions to access. You may want to adjust
            # the scope level as well (perhaps "ldap.SCOPE_SUBTREE", but
            # it can reduce performance if you don't need it).
            msgid = con.search_ext(
                base, ldap.SCOPE_SUBTREE, ldapfilter, attrlist, serverctrls=[lc]
            )
        except ldap.LDAPError as e:
            sys.exit("LDAP search failed: %s" % e)

        # Pull the results from the search request
        try:
            rtype, rdata, rmsgid, serverctrls = con.result3(msgid)
        except ldap.LDAPError as e:
            sys.exit("Could not pull LDAP results: %s" % e)

        # Each "rdata" is a tuple of the form (dn, attrs), where dn is
        # a string containing the DN (distinguished name) of the entry,
        # and attrs is a dictionary containing the attributes associated
        # with the entry. The keys of attrs are strings, and the associated
        # values are lists of strings.
        entries.extend(rdata)

        # Look through the returned controls and find the page controls.
        # This will also have our returned cookie which we need to make
        # the next search request.
        pctrls = [c for c in serverctrls if c.controlType == ldap.CONTROL_PAGEDRESULTS]
        if not pctrls:
            print >>sys.stderr, "Warning: Server ignores RFC 2696 control."
            break

        # Ok, we did find the page control, yank the cookie from it and
        # insert it into the control for our next search. If however there
        # is no cookie, we are done!
        cookie = pctrls[0].cookie
        if not cookie:
            break
        lc.cookie = cookie
    results = []
    for e in entries:
        if not e[0] == None:
            results.append(e)
    return results


def resolve_group(con, group_dn):
    return get_entries(
        con, ldapfilter="(memberof:1.2.840.113556.1.4.1941:=" + group_dn + ")"
    )


def get_connection_base(con):
    msgid = con.search("", ldap.SCOPE_BASE, attrlist=["rootDomainNamingContext"])
    unused_code, results, unused_msgid, serverctlrs = con.result3(msgid)
    return results[0][1]["rootDomainNamingContext"][0]


def find_by_samaccountname(con, sam):
    entries = get_entries(con, ldapfilter="(samaccountname=" + sam + ")")
    if len(entries) == 0:
        return None
    if len(entries) == 1:
        return entries[0]
    raise MultipleMatchingKeysError(
        "samaccountname "
        + sam
        + " matches more than one entry: "
        + ", ".join(map(lambda e: e[1].get("dc")[0], entries))
    )


def get_domains(con):
    entries = get_entries(con, ldapfilter="(objectclass=domain)")
    domains = []
    for e in entries:
        if not e[0] == None:
            domains.append(e[1].get("dc")[0])
    return domains


def dn2domain(dn):
    import re

    return re.split(",dc=", dn.lower(), 1)[1].replace(",dc=", ".")


def dn2domainid(dn):
    return dn2domain(dn).split(".")[0].upper()


def guid_to_string(binary_guid):
    import uuid

    return str(uuid.UUID(bytes_le=binary_guid)).lower()


class MultipleMatchingKeysError(Exception):
    pass


def get_connection(uri, username, password):

    # or set env var LDAPTLS_REQCERT=never
    ldap.set_option(ldap.OPT_X_TLS_REQUIRE_CERT, ldap.OPT_X_TLS_ALLOW)

    con = ldap.initialize(uri)
    # stupid magic code - required before binding or you get strange errors about
    # not being bound even though you are
    # ref: http://stackoverflow.com/questions/18793040/python-ldap-not-able-to-bind-successfully
    con.protocol_version = ldap.VERSION3
    con.set_option(ldap.OPT_REFERRALS, 0)
    # end magic code
    con.simple_bind_s(username.lower(), password)
    # bind_result = con.bind(username, self.opts["password"])
    # print "bind result: " + str(bind_result)
    return con


if len(sys.argv) != 4:
    print("Usage: {} uri username password".format(sys.argv[0]))
    sys.exit(1)

uri, username, password = sys.argv[1], sys.argv[2], sys.argv[3]

try:
    con = get_connection(uri, username, password)
    print("Connected ok")
except Exception as e:
    print("Failed to connect to {} as {}: {}".format(uri, username, e))
