#!/usr/bin/env python3


class IpGenerator(object):

    # pass in the list of things to iterate over
    def __init__(self, ips):
        self.ips = ips

    def __iter__(self):
        return self

    # Next iterates over a list.
    # Yield returns the value give to it
    # When next is called again, it picks up after yield and continues until it hits yield again
    # The advantage comes when looping through the list is expensive. Rather than processing the
    # entire list, you only process one, and if it's a usable IP, you never process the rest
    # of the IPs. Why not just have a method that returns the first usable IP? Because if it turns
    # out there is a problem with that IP, you can just call next and get the next IP, rather than
    # having to start through the list again.
    def next(self):
        print("  ipgen - start")
        for ip in self.ips:
            print("  ipgen - about to yield ip {}".format(ip))
            yield ip
            print("  ipgen - back from yield ip {}".format(ip))
        print("  ipgen - finish")


# create an IpGenerator to iterate through a list of IPs
ips = ["1.1.1.1", "1.1.1.2", "1.1.1.3"]
ipgenerator = IpGenerator(ips)

# use the ip generator by calling next
# note the output has main and ipgen interleaved
for ip in next(ipgenerator):
    print("main - next ip is {}".format(ip))
