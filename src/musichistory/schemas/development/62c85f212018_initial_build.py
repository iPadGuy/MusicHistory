"""Initial build

Revision ID: 62c85f212018
Revises: 
Create Date: 2022-11-01 08:59:18.860602

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '62c85f212018'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('dt_fileinfo',
    sa.Column('id', sa.BigInteger(), sa.Identity(always=True, start=100001), nullable=False),
    sa.Column('filename', sa.String(length=1024), nullable=False),
    sa.Column('asof', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    schema='media_library'
    )
    op.create_index('idx_fileinfo_asof_desc', 'dt_fileinfo', [sa.text('asof DESC')], unique=False, schema='media_library')
    op.create_index(op.f('ix_media_library_dt_fileinfo_asof'), 'dt_fileinfo', ['asof'], unique=False, schema='media_library')
    op.create_table('dt_playinfo',
    sa.Column('id', sa.BigInteger(), sa.Identity(always=False, start=100001), nullable=False),
    sa.Column('epochtime', sa.Float(), nullable=False),
    sa.Column('playdate', sa.Date(), nullable=False),
    sa.Column('playdatetime', sa.DateTime(timezone=True), nullable=False),
    sa.Column('filename', sa.String(length=1024), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('epochtime'),
    schema='media_library'
    )
    op.create_index(op.f('ix_media_library_dt_playinfo_epochtime'), 'dt_playinfo', ['epochtime'], unique=False, schema='media_library')
    op.create_index(op.f('ix_media_library_dt_playinfo_filename'), 'dt_playinfo', ['filename'], unique=False, schema='media_library')
    op.create_index(op.f('ix_media_library_dt_playinfo_playdate'), 'dt_playinfo', ['playdate'], unique=False, schema='media_library')
    op.create_index(op.f('ix_media_library_dt_playinfo_playdatetime'), 'dt_playinfo', ['playdatetime'], unique=False, schema='media_library')
    """op.create_table('dt_playinfo_test',
    sa.Column('id', sa.BigInteger(), sa.Identity(always=False, start=100001), nullable=False),
    sa.Column('epochtime', sa.Float(), nullable=False),
    sa.Column('playdate', sa.Date(), nullable=False),
    sa.Column('playdatetime', sa.DateTime(timezone=True), nullable=False),
    sa.Column('filename', sa.String(length=1024), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('epochtime'),
    schema='media_library'
    )
    op.create_index(op.f('ix_media_library_dt_playinfo_test_filename'), 'dt_playinfo_test', ['filename'], unique=False, schema='media_library')
    op.create_index(op.f('ix_media_library_dt_playinfo_test_playdate'), 'dt_playinfo_test', ['playdate'], unique=False, schema='media_library')
    op.create_index(op.f('ix_media_library_dt_playinfo_test_playdatetime'), 'dt_playinfo_test', ['playdatetime'], unique=False, schema='media_library')"""
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    """op.drop_index(op.f('ix_media_library_dt_playinfo_test_playdatetime'), table_name='dt_playinfo_test', schema='media_library')
    op.drop_index(op.f('ix_media_library_dt_playinfo_test_playdate'), table_name='dt_playinfo_test', schema='media_library')
    op.drop_index(op.f('ix_media_library_dt_playinfo_test_filename'), table_name='dt_playinfo_test', schema='media_library')
    op.drop_table('dt_playinfo_test', schema='media_library')"""
    op.drop_index(op.f('ix_media_library_dt_playinfo_playdatetime'), table_name='dt_playinfo', schema='media_library')
    op.drop_index(op.f('ix_media_library_dt_playinfo_playdate'), table_name='dt_playinfo', schema='media_library')
    op.drop_index(op.f('ix_media_library_dt_playinfo_filename'), table_name='dt_playinfo', schema='media_library')
    op.drop_index(op.f('ix_media_library_dt_playinfo_epochtime'), table_name='dt_playinfo', schema='media_library')
    op.drop_table('dt_playinfo', schema='media_library')
    op.drop_index(op.f('ix_media_library_dt_fileinfo_asof'), table_name='dt_fileinfo', schema='media_library')
    op.drop_index('idx_fileinfo_asof_desc', table_name='dt_fileinfo', schema='media_library')
    op.drop_table('dt_fileinfo', schema='media_library')
    # ### end Alembic commands ###
