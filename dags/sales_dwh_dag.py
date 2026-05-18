from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.common.sql.operators.sql import SQLExecutiveQueryOperator

POSTGRES_CONN_ID = 'sales_dwh'

with DAG(
    dag_id = "sales_dwh_pipeline",
    description = "Sales DWH ETL pipeline",
    start_date = datetime(2025, 1, 1),
    schedule = "@daily",
    catchup=False,
    tags=["dwh", "etl", "postgres"],
) as dag:
    
    extract_data = BashOperator(
        task_id="extract_data",
        bash_command="python /opt/airflow/scripts/generate_data.py",
    )

    create_staging_tables = SQLExecutiveQueryOperator(
        task_id="create_staging_tables",
        conn_id=POSTGRES_CONN_ID,
        sql="/opt/airflow/sql/staging/create_staging_tables.sql",
    )

    load_staging = BashOperator(
        task_id="load_staging",
        bash_command="python /opt/airflow/scripts/load_staging.py",
    )

    create_core_tables = SQLExecutiveQueryOperator(
        task_id="create_core_tables",
        conn_id=POSTGRES_CONN_ID,
        sql="/opt/airflow/sql/core/create_core_tables.sql",
    )

    load_core = SQLExecutiveQueryOperator(
        task_id="load_core",
        conn_id=POSTGRES_CONN_ID,
        sql="/opt/airflow/sql/core/load_core.sql",
    )

    build_marts = SQLExecutiveQueryOperator(
        task_id="build_marts",
        conn_id=POSTGRES_CONN_ID,
        sql="/opt/airflow/sql/marts/build_marts.sql",
    )

    data_quality_checks = SQLExecutiveQueryOperator(
        task_id="data_quality_checks",
        conn_id=POSTGRES_CONN_ID,
        sql="/opt/airflow/sql/quality/data_quality_checks.sql",
    )

    (
        extract_data
        >> create_staging_tables
        >> load_staging
        >> create_core_tables
        >> load_core
        >> build_marts
        >> data_quality_checks
    )

