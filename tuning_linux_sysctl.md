it's not quite that clean cut, but in general any server doing very high volume UDP in/out should up things like net.core.rmem_max/default, net.ipv4.udp_mem, etc. look at how the system is using these under load; you may need to up this a few times.

i'm less experienced with large streaming servers but there you want TCP performance tweaks, jumbo packets, more memory to buffer. bottom line is tune for what app you care about, check for what sysctls/buffers are starved and up them. RAM is cheap, engineers' sleep not so much.

ipv4.ip_forward

open file handles, sockets

net.ipv4.conf.all.send_redirects

obsecure tcp stack knobs: syn/ack retries, max orphans, tw reuse, fun timeout. and the others already mentioned (memory limits, forwarding, rp filter, core pattern, Max port/pid/inotify, default qdisc). sometimes VM settings

[Network Performance Monitoring](https://opensourceforu.com/2016/10/network-performance-monitoring/)
