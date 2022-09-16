#!/bin/bash
mode=$1
dbt_target=$2
dbt_vars=$3
full_refresh=$4

cd /app/

if [ $mode = "run" ]; then
    echo "dbt Mode is run"
    if [ $full_refresh = "True" ]; then
        echo "Doing a full refresh"
        # dbt run --target="$dbt_target"  --vars="$dbt_vars" --profiles-dir=/app/profiles_dir --full-refresh
        dbt debug --profiles-dir=/app/profiles_dir --target="$dbt_target"
    else
        echo "Not doing a full refresh"
        # dbt run --target="$dbt_target" --models="$dbt_models" --vars="$dbt_vars" --profiles-dir=/app/profiles_dir --full-refresh
        # dbt run --select=models/example/my_first_dbt_model.sql --target=projectzone --profiles-dir=/app/profiles_dir --full-refresh
        # dbt debug --profiles-dir=/app/profiles_dir --target="$dbt_target"
    fi
elif [ $mode = "debug" ]; then
    echo "dbt Mode is debug"
    dbt debug --profiles-dir=/app/profiles_dir --target="$dbt_target"
else   
    echo "Incorrect dbt Mode. Nothing to do"
fi

# capture the exit code from the dbt run command
# so that the final exit code form removing virtualenv cmd doesn't get used by KubernetesPodOperator 
exit_code=$?

# rethrowing the exit code to KubernetesPodOperator
exit $exit_code 