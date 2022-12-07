# models.py - Monday, June 13, 2022

import sys
import sqlalchemy as sa
from sqlalchemy.ext import hybrid
from sqlalchemy.ext.declarative import declarative_base
from pathlib import Path

basedir = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(basedir))

from config import Config

schema = Config.DB_SCHEMA
Base = declarative_base(metadata=sa.MetaData(schema=schema))


class PlayHistory(Base):
	__tablename__ = "dt_playhistory"
	id = sa.Column(sa.BigInteger, server_default=sa.Identity(start=100001), nullable=False, primary_key=True)
	epochtime = sa.Column(sa.Float, nullable=False, unique=True, index=True)
	playdate = sa.Column(sa.Date(), nullable=False, index=True)
	playdatetime = sa.Column(sa.DateTime(timezone=True), nullable=False, index=True)
	filename = sa.Column(sa.String(1024), index=True, nullable=False)
	play_secs = sa.Column(sa.Float, nullable=True)
	play_time = sa.Column(sa.Interval, nullable=True)
	skipped = sa.Column(sa.Boolean, nullable=True)

	def __repr__(self):
		return f"<PlayHistory: {self.id} {self.playdatetime} {self.filename}>"


class PlayInfo(Base):
	__table__ = sa.Table(
		"dt_playinfo", Base.metadata,
		sa.Column('id', sa.BigInteger(), server_default=sa.Identity(start=100001), nullable=False, primary_key=True),
		sa.Column("epochtime", sa.Float, nullable=False, unique=True, index=True),
		sa.Column("playdate", sa.Date(), nullable=False, index=True),
		sa.Column("playdatetime", sa.DateTime(timezone=True), nullable=False, index=True),
		sa.Column("filename", sa.String(1024), index=True, nullable=False),
		schema=schema,
	)

	def __repr__(self):
		return f"<PlayInfo: {self.id} {self.playdatetime} {self.filename}>"

