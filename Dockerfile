ARG project_id
ARG base_artifact
ARG base_image

FROM europe-west1-docker.pkg.dev/poc-bq2hana/base-dbt-docker/working-image
COPY . /app/
RUN echo "dbt via docker"

RUN chmod +x /app/dbt_run.sh
WORKDIR /app/
ENTRYPOINT ["/app/dbt_run.sh" ]