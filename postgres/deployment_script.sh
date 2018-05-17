#!/usr/bin/env bash
set -x
#1. ENABLE CloudSQL Administrator API
#2. If you don't have credentials.json localy, download credentials.json from GCP. #will use current user to save time.
#3. Terraform doesn't support CloudSQL POSTGRES yet

PROXY_KEY_FILE_PATH="~/.gce/credentials.json" #we will use the same user credentials to save time
POSTGRES_USER_PASSWORD="kiwipostgres" #password for main user
PROXY_USER_PASSWORD="kiwiproxy" #password for proxy user
PG_INSTANCE_NAME="kiwi-pg" # posgres instance name
export PROJECT_ID="$(gcloud config get-value project -q)"
export APPLICATION_IMAGE="eu.gcr.io/$PROJECT_ID/java_app:v1" #application image name that "will use connection to postgres" from previous task.

#Iitialize CloudSQL database
# gcloud sql instances create $PG_INSTANCE_NAME \
#        --tier db-f1-micro \
#        --database-version=POSTGRES_9_6 \
#        --storage-size=10GB
#        --region=europe-west2-a

#Create users and set passwords
gcloud sql users set-password postgres no-host --instance=$PG_INSTANCE_NAME --password=$POSTGRES_USER_PASSWORD #set password for main user
gcloud sql users create proxyuser host --instance=$PG_INSTANCE_NAME --password=$PROXY_USER_PASSWORD #set password for proxy user

#Create secrets for proxy container to connect to Database
kubectl create secret generic cloudsql-instance-credentials \
     --from-file=credentials.json=$PROXY_KEY_FILE_PATH
kubectl create secret generic cloudsql-db-credentials \
     --from-literal=username=proxyuser --from-literal=password=$PROXY_USER_PASSWORD

#Deploy application
connectionName=$(gcloud sql instances describe $PG_INSTANCE_NAME |grep connectionName | awk '{print $2}') #set connection endpoint variable
export connectionName

envsubst < pg-proxy.yml > pg.yml #set connection url for proxy and application image
kubectl apply -f pg.yml #apply Deployment
rm pg.yml

# Check connection
pod=$(kubectl get pod | grep kiwi-pg-deployment | awk '{print $1}') #set deployed pod name
kubectl exec -it $pod sh  # connect pod
psql postgresql://$POSTGRES_DB_USER:$POSTGRES_DB_PASSWORD@$POSTGRES_DB_HOST/postgres # test db connection
