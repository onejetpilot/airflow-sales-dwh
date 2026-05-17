import csv
import json
import random
import xml.etree.ElementTree as ET
from datetime import date, timedelta
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parents[1]
RAW_DIR = BASE_DIR / "data" / "raw"


def random_date(start: date, end: date) -> date:
    days = (end - start).days
    return start + timedelta(days=random.randint(0, days))


def generate_customers(count: int = 100) -> None:
    regions = {
        "Moscow": "Central",
        "Saint Petersburg": "Northwest",
        "Kazan": "Volga",
        "Novosibirsk": "Siberia",
        "Yekaterinburg": "Ural",
    }

    with open(RAW_DIR / "customers.csv", "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["customer_id", "customer_name", "email", "city", "region", "registration_date"])

        for customer_id in range(1, count + 1):
            city = random.choice(list(regions.keys()))
            writer.writerow([
                customer_id,
                f"Customer {customer_id}",
                f"customer{customer_id}@example.com",
                city,
                regions[city],
                random_date(date(2023, 1, 1), date(2025, 12, 31)),
            ])


def generate_products() -> None:
    products = [
        {"product_id": 1, "product_name": "Laptop", "category": "Electronics", "price": 900.00},
        {"product_id": 2, "product_name": "Smartphone", "category": "Electronics", "price": 600.00},
        {"product_id": 3, "product_name": "Office Chair", "category": "Furniture", "price": 150.00},
        {"product_id": 4, "product_name": "Desk", "category": "Furniture", "price": 250.00},
        {"product_id": 5, "product_name": "Coffee Machine", "category": "Appliances", "price": 300.00},
    ]

    with open(RAW_DIR / "products.json", "w", encoding="utf-8") as file:
        json.dump(products, file, indent=2)


def generate_orders(count: int = 1000) -> None:
    statuses = ["created", "paid", "shipped", "cancelled"]

    with open(RAW_DIR / "orders.csv", "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["order_id", "customer_id", "product_id", "order_date", "quantity", "order_status"])

        for order_id in range(1, count + 1):
            writer.writerow([
                order_id,
                random.randint(1, 100),
                random.randint(1, 5),
                random_date(date(2024, 1, 1), date(2025, 12, 31)),
                random.randint(1, 5),
                random.choice(statuses),
            ])


def generate_payments(order_count: int = 1000) -> None:
    methods = ["card", "cash", "bank_transfer"]
    statuses = ["success", "failed", "refunded"]

    root = ET.Element("payments")

    for payment_id in range(1, order_count + 1):
        payment = ET.SubElement(root, "payment")
        ET.SubElement(payment, "payment_id").text = str(payment_id)
        ET.SubElement(payment, "order_id").text = str(payment_id)
        ET.SubElement(payment, "payment_date").text = str(random_date(date(2024, 1, 1), date(2025, 12, 31)))
        ET.SubElement(payment, "payment_amount").text = str(round(random.uniform(50, 3000), 2))
        ET.SubElement(payment, "payment_method").text = random.choice(methods)
        ET.SubElement(payment, "payment_status").text = random.choice(statuses)

    tree = ET.ElementTree(root)
    tree.write(RAW_DIR / "payments.xml", encoding="utf-8", xml_declaration=True)


def main() -> None:
    RAW_DIR.mkdir(parents=True, exist_ok=True)

    generate_customers()
    generate_products()
    generate_orders()
    generate_payments()


if __name__ == "__main__":
    main()