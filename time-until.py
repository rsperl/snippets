#!/usr/bin/env python3

import calendar
import os
import sys
from datetime import datetime
from pathlib import Path

LAST_RUN_FILE = Path(f"{os.getenv('HOME') or ''}/tmp/.time_until_lr")
dates = [{"date": "2029-06-01", "output_prefix": "You can retire in "}]


def printerr(anything):
    print(anything, file=sys.stderr)


class TimeUntil:
    def __init__(self, years: int, months: int, days: int):
        self.years = years
        self.months = months
        self.days = days

    def __str__(self) -> str:
        lbl_years = "year"
        lbl_months = "month"
        lbl_days = "day"

        if self.years > 1:
            lbl_years += "s"
        if self.months > 1:
            lbl_months += "s"
        if self.days > 1:
            lbl_days += "s"
        return f"{self.years} {lbl_years}, {self.months} {lbl_months}, {self.days} {lbl_days}"


def time_to_run(last_run_file: Path) -> bool:
    if not last_run_file.exists():
        return True
    modified_at = datetime.fromtimestamp(int(last_run_file.stat().st_mtime))
    if modified_at.day != datetime.now().day:
        return True
    return False


def time_until(end_date: str) -> TimeUntil:
    then = datetime.strptime(end_date, "%Y-%m-%d")
    now = datetime.now()

    years = then.year - now.year
    months = then.month - now.month
    days = then.day - now.day
    if days < 0:
        days += calendar.monthrange(then.year, then.month)[1]
        months -= 1
    if months < 0:
        months += 12
        years -= 1
    return TimeUntil(years, months, days)


if time_to_run(LAST_RUN_FILE):
    printerr(f"[updating cache]")
    with open(LAST_RUN_FILE, "w") as fh:
        for d in dates:
            end_date = d["date"]
            prefix = d["output_prefix"]
            fh.write(f"{prefix}{time_until(end_date)}\n")
else:
    printerr(f"[reading from cache]")

with open(LAST_RUN_FILE) as fh:
    print(fh.read())
