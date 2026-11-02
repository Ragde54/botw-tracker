"""Postgres access: a small connection pool plus the two tables the app needs."""

import os

from psycopg_pool import ConnectionPool

DATABASE_URL = os.environ.get(
    "DATABASE_URL", "postgresql://botw:botw@localhost:5432/botw"
)

pool = ConnectionPool(conninfo=DATABASE_URL, open=False, min_size=1, max_size=4)

SCHEMA = """
CREATE TABLE IF NOT EXISTS piece_level (
    piece_id   text PRIMARY KEY,
    level      smallint NOT NULL CHECK (level BETWEEN 0 AND 4),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS skipped_set (
    set_id     text PRIMARY KEY,
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS inventory (
    material   text PRIMARY KEY,
    qty        integer NOT NULL CHECK (qty >= 0),
    updated_at timestamptz NOT NULL DEFAULT now()
);
"""


def init_schema() -> None:
    with pool.connection() as conn:
        conn.execute(SCHEMA)


def read_progress() -> tuple[dict[str, int], list[str]]:
    with pool.connection() as conn:
        levels = dict(
            conn.execute("SELECT piece_id, level FROM piece_level").fetchall()
        )
        skipped = [r[0] for r in conn.execute("SELECT set_id FROM skipped_set")]
    return levels, skipped


def write_progress(levels: dict[str, int], skipped: list[str]) -> None:
    """Replace the whole state in one transaction (the dataset is tiny)."""
    with pool.connection() as conn, conn.transaction():
        conn.execute("DELETE FROM piece_level")
        conn.execute("DELETE FROM skipped_set")
        with conn.cursor() as cur:
            cur.executemany(
                "INSERT INTO piece_level (piece_id, level) VALUES (%s, %s)",
                [(k, v) for k, v in levels.items() if v > 0],
            )
            cur.executemany(
                "INSERT INTO skipped_set (set_id) VALUES (%s)",
                [(s,) for s in skipped],
            )


def read_inventory() -> dict[str, int]:
    with pool.connection() as conn:
        return dict(conn.execute("SELECT material, qty FROM inventory").fetchall())


def set_inventory(material: str, qty: int) -> None:
    """Upsert one material; 0 units deletes the row to keep the table clean."""
    with pool.connection() as conn:
        if qty == 0:
            conn.execute("DELETE FROM inventory WHERE material = %s", (material,))
        else:
            conn.execute(
                """
                INSERT INTO inventory (material, qty) VALUES (%s, %s)
                ON CONFLICT (material) DO UPDATE
                SET qty = EXCLUDED.qty, updated_at = now()
                """,
                (material, qty),
            )
