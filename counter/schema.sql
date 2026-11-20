-- One row per counter. No other table, no other column.
CREATE TABLE IF NOT EXISTS counts (
  name TEXT PRIMARY KEY,
  n INTEGER NOT NULL DEFAULT 0
);
