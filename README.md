# Airflow Sales DWH

Учебный ETL-проект для построения витрины продаж в PostgreSQL. Данные генерируются локально, загружаются в staging-слой, затем преобразуются в core и marts через Airflow DAG.

## Стек

- Apache Airflow 3.2.1
- PostgreSQL 15
- Docker Compose
- Python, pandas, SQLAlchemy

## Структура

```text
dags/
  sales_dwh_dag.py              # Airflow DAG пайплайна
scripts/
  generate_data.py              # генерация raw-данных
  load_staging.py               # загрузка raw-данных в staging
sql/
  staging/create_staging_tables.sql
  core/create_core_tables.sql
  core/load_core_tables.sql
  marts/create_marts.sql
  quality/data_quality_checks.sql
  analytics/business_queries.sql
data/raw/                       # CSV, JSON и XML raw-данные
docker-compose.yml              # PostgreSQL + Airflow
requirements.txt
```

## Запуск

Поднять PostgreSQL и Airflow:

```bash
docker compose up -d
```

Проверить контейнеры:

```bash
docker compose ps
```

Airflow UI:

```text
http://localhost:8080
```

Логин и пароль:

```text
admin / admin
```

PostgreSQL доступен с хоста:

```text
localhost:5434
database: sales_db
user: sales_user
password: sales_password
```

Внутри Docker-сети Airflow подключается к PostgreSQL по адресу:

```text
postgress:5432
```

## Airflow DAG

DAG:

```text
sales_dwh_pipeline
```

Последовательность задач:

```text
extract_data
create_staging_tables
load_staging
create_core_tables
load_core
build_marts
data_quality_checks
```

Пайплайн делает следующее:

1. Генерирует raw-данные в `data/raw`.
2. Создает staging-таблицы.
3. Загружает CSV, JSON и XML в staging.
4. Создает core-таблицы.
5. Загружает измерения и факт заказов.
6. Строит mart-таблицы.
7. Выполняет проверки качества данных.

В DAG задано `max_active_runs=1`, чтобы несколько запусков одновременно не писали в одни и те же raw-файлы.

## Полезные команды

Посмотреть логи Airflow:

```bash
docker compose logs -f airflow
```

Пересоздать Airflow-контейнер после изменения `docker-compose.yml`:

```bash
docker compose up -d --force-recreate airflow
```

Выполнить генерацию данных вручную:

```bash
docker compose exec airflow python /opt/airflow/scripts/generate_data.py
```

Проверить конкретную задачу Airflow:

```bash
docker compose exec airflow airflow tasks test sales_dwh_pipeline load_staging 2026-05-18
```

Подключиться к PostgreSQL:

```bash
docker compose exec postgress psql -U sales_user -d sales_db
```

## SQL-слои

- `staging` хранит данные как они пришли из raw-файлов.
- `core` содержит измерения и факт заказов.
- `marts` содержит аналитические витрины:
  - `marts.mart_daily_sales`
  - `marts.mart_customer_ltv`
  - `marts.mart_product_performance`

Файл `sql/analytics/business_queries.sql` содержит примеры бизнес-запросов к витринам и запускается вручную.

## Остановка

Остановить контейнеры:

```bash
docker compose down
```

Остановить контейнеры и удалить volume PostgreSQL:

```bash
docker compose down -v
```
