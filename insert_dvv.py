import csv
import psycopg
from datetime import datetime
import sys

# --- Database connection setup ---
conn = psycopg.connect(
    dbname="postgres",
    user="postgres",
    password="postgres",
    host="localhost",  # or your DB host
    port="5432",
    autocommit=False
)

# --- Configuration ---
CSV_FILE = "Finland_addresses_2024-02-13.csv"
DEFAULT_LANGUAGE = "finnish"
DEFAULT_SOURCE = "DATA_HUB"
DEFAULT_ADDRESS_TYPE = "MAIN"
DEFAULT_GRID_AREA = None

# --- Insert query ---
INSERT_QUERY = """
INSERT INTO address (
    postal_code,
    street,
    house_number,
    staircase,
    apartment
) VALUES (
    %(postal_code)s,
    %(street)s,
    %(house_number)s,
    %(staircase)s,
    %(apartment)s
) ON CONFLICT DO NOTHING;
"""

# --- Insert rows one by one ---
with conn.cursor() as cur, open(CSV_FILE, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for i, row in enumerate(reader, 1):
        try:
            if row.get("street"):
                data = {
                    "postal_code": row.get("postal_code"),
                    "street": row.get("street"),
                    "house_number": row.get("house_number"),
                    "staircase": None,
                    "apartment": None
                }

                cur.execute(INSERT_QUERY, data)
                conn.commit()
                print(f"✅ Inserted row {i}")
        except Exception as e:
            conn.rollback()
            print(f"❌ Failed to insert row {i}: {e}")
            sys.exit(1)


# --- Close connection ---
conn.close()
