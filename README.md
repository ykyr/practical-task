### Task 1

Prepare environment

1. Download sources.
2. Configure gcloud unitily to work with current project.  
```
gcloud auth login
gcloud config list project
gcloud config list
```
3. Download credentials.json due to official [documentation](https://www.terraform.io/docs/providers/google/index.html#authentication-json-file).
4. Configure path to ``credentials.json`` file in ``main.tf``
5. Install GKE.
```
cd terraform
terrafrom plan
terrafrom apply
```
Build docker image
6. Change directory to "application/java"
```
cd application
```
7. Configure docker to use Google container registry. (gcloud should be already configured to your project)
```
gcloud alpha auth configure-docker
```
8. Build docker image and according to PROJECT_ID
You can use following command to get PROJECT_ID
```
export PROJECT_ID="$(gcloud config get-value project -q)"
echo $PROJECT_ID
```
```
docker build -t eu.gcr.io/$PROJECT_ID/java_app:v1 .
```
Check application
```
docker run --rm eu.gcr.io/$PROJECT_ID/java_app:v1
```
9. Push image to google cloud registry
```
docker push eu.gcr.io/$PROJECT_ID/java_app:v1
```
11. Prepare kubectl to work with deployed k8s.
```
gcloud container clusters get-credentials k8skiwi-cluster --zone europe-west2-a --project $PROJECT_ID
```
12. Set correct ``image`` name in ``kubernetes/deployment.yml`` (from previous push)
13. Deploy application, service and ingress to Kubernetes
```
cd kubernetes
kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f ingress.yml
```
14. Get ingress external endpoint and check connection
```
kubectl get ingress
```

### [Task 2](https://github.com/ykyr/practical-task/blob/master/postgres/README.md)
