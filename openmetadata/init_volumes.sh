if [ "\$1" = "delete" ]; then
    rm -rf ./volumes
fi

mkdir -p ./volumes/airflow/dag_generated_configs
mkdir -p ./volumes/airflow/dags
mkdir -p ./volumes/tmp
mkdir -p ./volumes/elasticsearch
mkdir -p ./volumes/postgresql
mkdir -p ./docker/postgresql/docker-entrypoint-initdb.d
mkdir -p ./volumes/python/metadata
mkdir -p ./volumes/python/gunicorn
mkdir -p ./volumes/python/pydantic
