import pandas as pd
import xml.etree.ElementTree as ET
from pathlib import Path
from sqlalchemy import create_engine

BASE_DIR = Path(__file__).resolve().parents[1]
RAW_DIR = BASE_DIR / 'data' / 'raw'

DB_URL = "postgresql+psycopg2://sales_user:sales_password@localhost:5434/sales_db"

def load_csv(file_name: str, table_name: str, engine) -> None:
    df = pd.read_csv(RAW_DIR / file_name)
    df.to_sql(table_name, engine, schema="staging", if_exists="append", index=False)

def load_json(file_name: str, table_name: str, engine) -> None:
    df = pd.read_json(RAW_DIR / file_name)
    df.to_sql(table_name, engine, schema="staging", if_exists="append", index=False)             
              
def load_payments_xml(file_name: str, table_name: str, engine) -> None:
    tree = ET.parse(RAW_DIR / file_name)
    root = tree.getroot()

    rows = []
    for payment in root.findall("payment"):
        rows.append({
            "payment_id": int(payment.findtext("payment_id")),
            "order_id": int(payment.findtext("order_id")),
            "payment_date": payment.findtext("payment_date"),
            "payment_amount": float(payment.findtext("payment_amount")),
            "payment_method": payment.findtext("payment_method"),
            "payment_status": payment.findtext("payment_status"),
        })

    df = pd.DataFrame(rows)
    df.to_sql(table_name, engine, schema = "staging", if_exists="append", index=False)

def clear_staging_tables(engine) -> None:
    with engine.begin() as conn:
        conn.exec_driver_sql("TRUNCATE TABLE staging.stg_orders;")
        conn.exec_driver_sql("TRUNCATE TABLE staging.stg_customers;")
        conn.exec_driver_sql("TRUNCATE TABLE staging.stg_payments;")
        conn.exec_driver_sql("TRUNCATE TABLE staging.stg_products;")

def main() -> None:
    engine = create_engine(DB_URL)

    clear_staging_tables(engine)

    load_csv("orders.csv", "stg_orders", engine)
    load_csv("customers.csv", "stg_customers", engine)
    load_json("products.json", "stg_products", engine)
    load_payments_xml("payments.xml", "stg_payments", engine)

    print("Данные загружены в staging.")

if __name__ == "__main__":
    main()


     

