# models.py - Monday, June 13, 2022

import sys
import sqlalchemy as sa
from pathlib import Path
from sqlalchemy.ext.declarative import declarative_base

basedir = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(basedir))

from config import Config

schema = Config.DB_SCHEMA
Base = declarative_base(metadata=sa.MetaData(schema=schema))


class PlayInfo(Base):
	__table__ = sa.Table(
		"dt_playinfo", Base.metadata,
		sa.Column('id', sa.BigInteger(), server_default=sa.Identity(start=100001), nullable=False, primary_key=True),
		sa.Column("epochtime", sa.Float, nullable=False, unique=True),
		sa.Column("playdate", sa.Date(), nullable=False, index=True),
		sa.Column("playdatetime", sa.DateTime(timezone=True), nullable=False, index=True),
		sa.Column("filename", sa.String(1024), index=True, nullable=False),
		schema=schema,
	)

	def __repr__(self):
		return f"<PlayInfo: {self.id} {self.playdatetime} {self.filename}>"


class FileInfo(Base):
	__table__ = sa.Table(
		"dt_fileinfo",
		Base.metadata,
		sa.Column("id", sa.BigInteger, sa.Identity(start=100001, always=True), primary_key=True),
		sa.Column("filename", sa.String(1024), nullable=False, unique=False),
		sa.Column("asof", sa.DateTime(timezone=True), index=True, nullable=False, server_default=sa.func.now()),
		schema=schema,
	)
	sa.Index('idx_fileinfo_asof_desc', __table__.columns.asof.desc()),

	def __repr__(self):
		return f"<FileInfo: {self.id} {self.filename} {self.asof}>"


"""class PlayInfoTest(Base):
	__table__ = sa.Table(
		"dt_playinfo_test", Base.metadata,
		sa.Column('id', sa.BigInteger(), server_default=sa.Identity(start=100001), nullable=False, primary_key=True),
		sa.Column("epochtime", sa.Float, nullable=False, unique=True),
		sa.Column("playdate", sa.Date(), nullable=False, index=True),
		sa.Column("playdatetime", sa.DateTime(timezone=True), nullable=False, index=True),
		sa.Column("filename", sa.String(1024), index=True, nullable=False),
		schema=schema,
	)

	def __repr__(self):
		return f"<PlayInfo: {self.id} {self.playdatetime} {self.filename}>"

"""
