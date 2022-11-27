#!/home/patrick/.local/share/virtualenvs/MusicHistory-nP00uPHO/bin/python
# -*- coding: utf-8 -*-
# generate_lists.py - Sunday, November 27, 2022
""" Generate dates for calling build_top_lists """
__version__ = "0.1.0-dev2"

import calendar, os, sys
from datetime import datetime, timedelta, timezone
from glob import glob
from os.path import exists, expanduser, join
from subprocess import check_output

__MODULE__ = os.path.splitext(os.path.basename(__file__))[0]


def main():
    dates = []
    c = calendar.Calendar(firstweekday=6)
    for year in range(2017,2023):
        for month in range(1,13):
            for week in c.monthdatescalendar(year, month):
                eow = week[-1]
                if eow > _run_dt.date():
                    continue
                # print(f"End of Week : {eow}")
                dates.append(eow)
            days_in_month = calendar.monthrange(year, month)[1]
            eom = datetime(year, month, days_in_month).date()
            if eom > _run_dt.date():
                continue
            # print(f"End of Month: {eom}")
            dates.append(eom)
    filename = os.path.expanduser("~/Projects/MusicHistory/dates.txt")
    with open(filename, "w") as datefile:
        datefile.writelines([f"{x}\n" for x in dates])
    return


def init():
    print("Run Start: %s" % _run_dt)
    return


def eoj():
    stop_dt = datetime.now().astimezone().replace(microsecond=0)
    duration = stop_dt.replace(microsecond=0) - _run_dt.replace(microsecond=0)
    print("Run Stop : %s  Duration: %s" % (stop_dt, duration))
    return


def do_nothing():
    pass


if __name__ == '__main__':
    _run_dt = datetime.now().astimezone().replace(microsecond=0)
    _run_utc = _run_dt.astimezone(timezone.utc).replace(tzinfo=None)
    _fdate = _run_dt.strftime("%Y-%m-%d")
    _fdatetime = _run_dt.strftime("%Y%m%d_%H%M%S")

    # init()
    main()
    # eoj()
