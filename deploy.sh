# Create tags for images
docker build -t zhukmj/multi-client:latest -t zhukmj/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t zhukmj/multi-server:latest -t zhukmj/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t zhukmj/multi-worker:latest -t zhukmj/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push tags
docker push zhukmj/multi-client:latest
docker push zhukmj/multi-server:latest
docker push zhukmj/multi-worker:latest
docker push zhukmj/multi-client:$SHA
docker push zhukmj/multi-server:$SHA
docker push zhukmj/multi-worker:$SHA

# Apply k8s config files
kubectl apply -f k8s 

# Bypass caching by making use of git sha tags
kubectl set image deployments/client-deployment client=zhukmj/multi-client:$SHA
kubectl set image deployments/server-deployment server=zhukmj/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=zhukmj/multi-worker:$SHA