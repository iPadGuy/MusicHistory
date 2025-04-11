#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# log_maintenance.py - Friday, April 4, 2025
""" Performs Log Maintenance: creating tarballs of old log files and re-packing old merged files """
__version__ = "0.1.0-dev18"

import builtins
import concurrent.futures
import lzma
import os
import re
import shutil
import sys
import time
import tarfile
from contextlib import contextmanager
from datetime import datetime, timedelta, timezone
from environs import Env
from glob import glob
from os.path import abspath, basename, dirname, getmtime, getsize, exists, join
from pathlib import Path
from subprocess import run
from time import sleep
from timeit import default_timer as timer

import click
import pandas as pd
import sqlalchemy as sa
import xdg_base_dirs as xdg
from dateutil.parser import parse, ParserError
from loguru import logger
from sqlalchemy import create_engine, text
# from tabulate import tabulate
# from xdg import XDG_DATA_HOME, XDG_CONFIG_HOME

appname = "MusicHistory"
_basedir = Path(__file__).resolve().parent.parent
__org__ = "LevellTech"
__project__ = _basedir.stem
# __project__ = appname
__module__ = Path(__file__).resolve().stem
# config_dir = xdg.xdg_config_home()
_config_dir = xdg.xdg_config_home() / __org__ / __project__

# if not _config_dir:
# 	config_dir = os.path.expanduser("~/.config")
# if appname:
# 	config_dir = os.path.join(config_dir, appname)
try:
	sys.path.insert(0, str(_config_dir))
	from config import Config  # noqa
except ModuleNotFoundError:
	logger.error(_config_dir)
	raise ModuleNotFoundError("config.py")


def main():
	yesterday_ts = _run_ts - 86400
	os.chdir(_data_dir)
	for entry in sorted([x for x in os.scandir() if x.is_dir() and x.name != "Summaries" and getmtime(x.path) < yesterday_ts], key=lambda d: d.name):
		date_subdir = entry.name
		try:
			create_tarball(date_subdir)
		except FileExistsError as fe:
			logger.warning(fe)
		# logfiles = glob(join(entry.path, "smplayer*log*"))
		# n = len(logfiles)
		# if n > 10:
		# 	print(f"{date_subdir}: {n}")
		# if len(matches) > 0:
		# 	print(date_subdir)
		# 	if len(matches) > 10:
		# 		print(matches)
	return


def init():
	started = time.strftime(_iso_datefmt, _run_localtime)
	logger.info(f"Run Start: {__module__} v{__version__} {started}")
	return


def eoj():
	stop_ts = time.time()
	stop_localtime = time.localtime(stop_ts)
	stop_gmtime = time.gmtime(stop_ts)
	duration = timedelta(seconds=(stop_ts - _run_ts))
	logger.info(f"Run Stop : {time.strftime(_iso_datefmt, stop_localtime)}  Duration: {duration}")
	return


def do_nothing():
	pass


def create_tarball(date_subdir: str):
	olddir = os.getcwd()
	os.chdir(date_subdir)
	logger.info(f"Entering {date_subdir} . . .")
	filenames = [x.path for x in os.scandir() if
				 x.name.startswith("smplayer") and x.name.endswith((".log", "log.xz"))]
	tarfilename = None
	if filenames:
		filenames = sorted(filenames, key=getmtime)
		last_mtime = getmtime(filenames[-1])
		tarfilename = f"smplayer_logs_{date_subdir}.txz"
		if exists(tarfilename):
			tarfilename = f"smplayer_logs_{date_subdir}-2.txz"
		logger.info(f"Creating Archive '{tarfilename}' . . .")
		try:
			with tarfile.open(tarfilename, "w:xz") as tar:
				for filename in filenames:
					if filename.endswith("log.xz"):
						# logger.info(f"  {date_subdir} Decompressing '{filename}' . . .")
						unxz(filename)
						filename = filename.rstrip(".xz")
					tar.add(filename)
		except Exception as e:
			logger.exception(e)
			do_nothing()
		else:
			os.utime(tarfilename, times=(last_mtime, last_mtime))
			for entry in [x for x in os.scandir() if x.name.startswith("smplayer") and x.name.endswith("log")]:
				os.remove(entry.path)
			# os.chdir("..")
			os.utime(f"../{date_subdir}", times=(last_mtime, last_mtime))
	os.chdir(olddir)
	return tarfilename


def unxz(filename: str | Path):
	cmd = ["unxz", filename,]
	result = run(cmd)


if __name__ == '__main__':
	_run_ts = time.time()
	_run_dt = datetime.fromtimestamp(_run_ts).astimezone()
	_run_localtime = time.localtime(_run_ts)
	_run_gmtime = time.gmtime(_run_ts)
	_run_ymd = time.strftime("%Y%m%d", _run_localtime)
	_run_hms = time.strftime("%H%M%S", _run_localtime)
	_run_ymdhms = f"{_run_ymd}_{_run_hms}"
	_iso_datefmt = "%Y-%m-%d %H:%M:%S%z"

	# Configure Directories
	_cache_dir = xdg.xdg_cache_home() / __org__ / __project__
	_config_dir = xdg.xdg_config_home() / __org__ / __project__
	_data_dir = xdg.xdg_data_home() / __org__ / __project__
	_runtime_dir = xdg.xdg_runtime_dir() / __org__ / __project__
	_state_dir = xdg.xdg_state_home() / __org__ / __project__
	# Sub-Directories
	_log_dir = _state_dir / "log"

	# Configure Database
	engine = create_engine(Config.DATABASE_URL)
	schema = Config.NEW_DB_SCHEMA
	tablename = Config.TABLE_NAME

	# SET PosgreSQL search_path
	@sa.event.listens_for(engine, "connect", insert=True)
	def set_search_path(dbapi_connection, connection_record):
		"""
		Set schema search path in database
		"""
		sql = f"SET SESSION search_path TO {schema},public;"
		existing_autocommit = dbapi_connection.autocommit
		dbapi_connection.autocommit = True
		cursor = dbapi_connection.cursor()
		cursor.execute(sql)
		cursor.close()
		dbapi_connection.autocommit = existing_autocommit

	# Loguru Configuration (logger)
	_logfile = _log_dir / f"{__module__}.log"
	_errfile = _log_dir / f"{__module__}.err"

	logger.remove(0)
	logger.add(
		sys.stderr,
		backtrace=True,
		colorize=True,
		diagnose=True,
		format="<level>{level:8s} {function}:{line:03d}  {message}</level>",
		level="DEBUG",
	)
	logger.add(
		_logfile,
		colorize=False,
		compression="gz",
		format="<green>{time:%Y-%m-%d %H:%M:%S%z}</green> <level>{level:8s} {name}:{function}:{line:03d}  {message}</level>",
		rotation="10 MB",
		level="TRACE",
	)
	logger.add(
		_errfile,
		colorize=False,
		compression="gz",
		format="<green>{time:%Y-%m-%d %H:%M:%S%z}></green> <level>{level:8s} {name}:{function}:{line:03d}  {message}</level>",
		rotation="10 MB",
		level="ERROR",
	)
	# logger.add("debug.log", rotation="10 MB", level="DEBUG")
	# logger.add("info.log", rotation="10 MB", level="INFO")
	# logger.add("warning.log", rotation="10 MB", level="WARNING")
	# logger.add("critical.log", rotation="10 MB", level="CRITICAL")

	init()
	main()
	eoj()
