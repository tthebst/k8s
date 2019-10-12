#run this on master node
# sh reset_all.sh "cloudflare api token" "aws id" "aws secret" 


#create RBAC for traefik
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-rbac.yaml

#setup secets and deploy traefik
echo -n 'gretler.tim@gmail.com' > /home/pi/username.txt
echo -n '$5' > /home/pi/api_token.txt
echo -n '$6' > /home/pi/aws_key.txt
echo -n '$7' > /home/pi/aws_key_access.txt
kubectl create secret generic cloudfare-dns  --from-file=/home/pi/username.txt --from-file=/home/pi/api_token.txt
kubectl create secret generic aws --from-file=/home/pi/aws_key.txt --from-file=/home/pi/aws_key_access.txt
kubectl apply -f traefik_deamon.yaml
kubectl apply -f traefik_service.yaml
kubectl apply -f traefik_config.yaml

#deploy maetallb 
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl apply -f metallb_config.yaml

kubectl apply -f deployments.yaml
kubectl apply -f deployment_service.yaml
kubectl apply -f ingress.yaml