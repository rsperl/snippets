# Graph # of connections for each hosts
netstat -an |
  grep ESTABLISHED |
  awk '{print $5}' |
  awk -F: '{print $1}' |
  grep -v -e '^[[:space:]]*$' |
  sort | uniq -c |
  awk '{ printf("%s\t%s\t",$2,$1) ; for (i = 0; i < $1; i++) {printf("*")}; print "" }'

# Monitor open connections for specific port including listen, count and sort it per IP
watch "netstat -plan | grep :443 | awk {'print \$5'} | cut -d: -f 1 | sort | uniq -c | sort -nk 1"
