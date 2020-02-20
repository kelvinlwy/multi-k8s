#build, apply configs, set latest images on each deployment

# tag with GIT_SHA -> is also easy for debugging by git checkout GIT_SHA to look at the commit

docker build -t kelvinlwy/multi-client:latest -t kelvinlwy/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t kelvinlwy/multi-server:latest -t kelvinlwy/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t kelvinlwy/multi-worker:latest -t kelvinlwy/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push kelvinlwy/multi-client:latest
docker push kelvinlwy/multi-client:$SHA
docker push kelvinlwy/multi-server:latest
docker push kelvinlwy/multi-server:$SHA
docker push kelvinlwy/multi-worker:latest
docker push kelvinlwy/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=kelvinlwy/multi-server:$SHA
kubectl set image deployments/client-deployment server=kelvinlwy/multi-client:$SHA
kubectl set image deployments/server-deployment server=kelvinlwy/multi-worker:$SHA

# unique tags for built images to make sure deployment pulling latest image everytime based on the version which differeniate versions
