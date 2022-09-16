from airflow import DAG
from airflow import models
# Make sure to add below
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.utils.dates import days_ago
from airflow.configuration import conf




args = {
    'owner': 'dummy',
    'retries': 0,
}

docker_dag = DAG(
    dag_id='dbt_docker_test',
    default_args=args,
    schedule_interval=None,
    start_date=days_ago(1),
    catchup=False,
    tags=['dbt run model'],
)

quay_k8s = KubernetesPodOperator(
    # k8s namespace created earlier
    namespace= 'k8-dbt-composer', 
    # k8s service account name created earlier
    service_account_name='composer-dbt',
    # in_cluster=True,
    # Ensures that the right node-pool is used
    # node_selector={'http://cloud.google.com/gke-nodepool': 'pool-1'}, 
    # Ensures that cache is always refreshed
    image_pull_policy='Always', 
    # Artifact image of dbt repo
    # image='europe-west1-docker.pkg.dev/poc-bq2hana/dbt-repo/my-image',
    image='europe-west1-docker.pkg.dev/poc-bq2hana/dbt-repo/my-image',
    # links to ENTRYPOINT in .sh file
    # cmds=['/app/dbt_run.sh'], 
    cmds = ['/app/dbt_run.sh'],
    # arguments=["print('This code is running in a Kubernetes Pod')"],
    # labels={},
    # matches sequence of arguments in .sh file (mode,dbt_target,dbt_vars,full_refresh)
    arguments=['run','dev','{from_date: "", to_date: ""}','True'],  
    name="run-dbt-in-pod",
    task_id="run-dbt-in-pod",
    get_logs=True,
    log_events_on_failure=True,
    dag=docker_dag,    
    )

