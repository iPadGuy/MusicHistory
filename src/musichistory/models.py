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


class FolderInfo(Base):
	__table__ = sa.Table(
		"dt_folderinfo",
		Base.metadata,
		sa.Column("id", sa.BigInteger, sa.Identity(start=100001, always=True), primary_key=True),
		sa.Column("foldername", sa.String(1024), nullable=False, unique=False),
		sa.Column("asof", sa.DateTime(timezone=True), index=True, nullable=False, server_default=sa.func.now()),
		schema=schema,
	)
	sa.Index('idx_folderinfo_asof_desc', __table__.columns.asof.desc()),

	def __repr__(self):
		return f"<FileInfo: {self.id} {self.filename} {self.asof}>"


"""
 empno | ename  |    job    | mgr  |  hiredate  |   sal   |  comm   | deptno 
  7369 | SMITH  | CLERK     | 7902 | 1980-12-17 |  800.00 |         |     20
  7499 | ALLEN  | SALESMAN  | 7698 | 1981-02-20 | 1600.00 |  300.00 |     30
  7521 | WARD   | SALESMAN  | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30
  7566 | JONES  | MANAGER   | 7839 | 1981-04-02 | 2975.00 |         |     20
  7654 | MARTIN | SALESMAN  | 7698 | 1981-09-28 | 1250.00 | 1400.00 |     30
  7698 | BLAKE  | MANAGER   | 7839 | 1981-05-01 | 2850.00 |         |     30
  7782 | CLARK  | MANAGER   | 7839 | 1981-06-09 | 2450.00 |         |     10
  7788 | SCOTT  | ANALYST   | 7566 | 1987-04-19 | 3000.00 |         |     20
  7839 | KING   | PRESIDENT |      | 1981-11-17 | 5000.00 |         |     10
  7844 | TURNER | SALESMAN  | 7698 | 1981-09-08 | 1500.00 |    0.00 |     30
  7876 | ADAMS  | CLERK     | 7788 | 1987-05-23 | 1100.00 |         |     20
  7900 | JAMES  | CLERK     | 7698 | 1981-12-03 |  950.00 |         |     30
  7902 | FORD   | ANALYST   | 7566 | 1981-12-03 | 3000.00 |         |     20
  7934 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300.00 |         |     10
"""

class FolderInfo0(Base):

	__table__ = sa.Table(
		'dt_folder_info',
		Base.metadata,
		sa.Column('id', sa.Integer, sa.Identity(start=10001), primary_key=True),
		sa.Column('pathname', sa.String(length=255), index=True, unique=True, nullable=False),
		# Replaced with hybrid column
		# sa.Column('avg_days', Numeric, server_default=sa.sql.expression.literal(0), nullable=False),
		# sa.Column('span_days', Numeric),
		sa.Column('video_count', sa.Integer, nullable=False),
		sa.Column('video_size', sa.BigInteger, nullable=False),
		sa.Column('newest_ts', sa.DateTime(timezone=True), nullable=False),
		sa.Column('oldest_ts', sa.DateTime(timezone=True), nullable=False),
		sa.Column('med_duration', sa.Numeric),
		sa.Column('med_size', sa.Numeric),
		sa.Column('asof', sa.DateTime(timezone=True), index=True, nullable=False,
		       server_default=sa.func.now()),
	)
	@hybrid.hybrid_property
	def size_gb(self):
		return self.video_size / 1024**3

	@hybrid.hybrid_property
	def size_mb(self):
		return self.video_size / 1024**2

	@hybrid.hybrid_property
	def bytes_per_day(self):
		return self.video_size / self.span_days

	@hybrid.hybrid_property
	def videos_per_day(self):
		return self.video_count / self.span_days

	def __repr__(self):
		return "<FolderInfo: %s videos: %d video_size: %d>" \
		       % (self.pathname, self.video_count, self.video_size)

	sa.Index('idx_folder_info_asof_desc', __table__.columns.asof.desc())

	# Create a table trigger to automatically update the asof column
	create_trigger = sa.DDL("""
		CREATE OR REPLACE FUNCTION fn_folder_info_asof() RETURNS trigger
			LANGUAGE 'plpgsql' AS $$
		BEGIN
			IF NEW.asof IS NULL THEN
				NEW.asof = now();
			END IF;
			RETURN NEW;
		END; $$;

		CREATE TRIGGER tra_folder_info_asof AFTER UPDATE ON dt_folder_info
			FOR EACH ROW
				EXECUTE PROCEDURE fn_folder_info_asof();
	""")
	# Create listener to create the triggers after the table is created
	sa.event.listen(__table__, 'after_create', create_trigger)


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
