### Task 2

1. [**ENABLE** CloudSQL Administrator API](https://console.cloud.google.com/flows/enableapi?apiid=sqladmin&redirect=https://console.cloud.google.com&_ga=2.76296597.-1293585776.1526543950)
2. If you don't have credentials.json localy, download credentials.json from GCP. Will use current user to save time.
3. Terraform doesn't support CloudSQL POSTGRES yet, so let's create CloudSQL with gcloud
```
gcloud sql instances create kiwi-pg \
       --tier db-f1-micro \
       --database-version=POSTGRES_9_6 \
       --storage-size=10GB
       --region=europe-west2-a
```
where ``kiwi-pg`` - database instance name.

4. Use [deployment_script.sh](https://github.com/ykyr/practical-task/blob/master/postgres/deployment_script.sh) to install all resources. It will:
  - Create ``proxyuser`` with password
  - Create k8s secrets that proxy application will use connect to database
  - Set endpoints in pg-proxy.yml according to variables
  - Create k8s deployment, where pod will consists of application container and db-proxy container
  - Connect inside the pod and check db connectivity. (application image has preinstalled psql client for test purpose)
  ```
  psql postgresql://$POSTGRES_DB_USER:$POSTGRES_DB_PASSWORD@$POSTGRES_DB_HOST/postgres
  ```
