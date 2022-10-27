#!/usr/bin/env python
# -*- coding: utf-8 -*-

import dns.resolver

res = dns.resolver.Resolver()
ans = res.query("www.google.com", "A")
print("ans={}".format(ans))
