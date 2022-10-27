#!/usr/bin/env python

from datetime import datetime


def get_third_weekend_dates(year, month):
    """
    Returns a tuple of the dates of Sat and Sun for TWMNT for the given year and month
    """
    day1 = datetime(year, month, 1)
    weekday = day1.weekday()
    if weekday == 0:     # Mon
        return (20, 21)
    elif weekday == 1:   # Tue
        return (19, 20)
    elif weekday == 2:   # Wed
        return (18, 19)
    elif weekday == 3:   # Thu
        return (17, 18)
    elif weekday == 4:   # Fri
        return (16, 17)
    elif weekday == 5:   # Sat
        return (15, 16)
    elif weekday == 6:   # Sun
        return (21, 22)


def is_third_weekend_day():
    """
    Returns True if today is a TWMNT day, False otherwise
    """
    now = datetime.now()
    if now.day in get_third_weekend_dates(now.year, now.month):
        return True
    return False


if __name__ == "__main__":
    year = datetime.now().year
    for month in range(1, 13):
        sat, sun = get_third_weekend_dates(year, month)
        print("{}-{}: sat={}, sun={}".format(year, month, sat, sun))
