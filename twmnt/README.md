# Third Weekend Maint Module

Determines what the TWMNT dates for a given month are and whether today is a TWMNT day

## Usage

**Python**
```python
import sas3w

year = 2017
month = 4
saturday, sunday = sas3w.get_third_weekend_dates(year, month)
# saturday = 15, sunday = 16

# given that this is April 16th, 2017 (a TWMNT day):
if is_third_weekend_day():
    # execute TWMNT code
```

**Shell**
```shell
source sas3w.sh

year=2017
month=4
dates=$(get_third_weekend_dates $year $month)
# 15 16

[[ is_third_weekend_day == 1 ]] && /run/this/command
```

**Perl** (taken from [```test.pl```](test.pl))
```perl
#!/usr/bin/env perl

use lib ".";
use sas3w;

if( is_third_weekend_day ) {
  print "It's third weekend\n";
} else {
  print "It's not third weekend\n";
}
```