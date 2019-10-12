#run this on master node
# sh reset_all.sh "new_passwd" "curr ip pi1" "curr ip pi2" "curr ip pi2" "curr ip pi2" "cloudflare api token" "aws id" "aws secret" 
python3 reset_script.py $1 $2 $3 $4 $5 $6 $7


#create RBAC for traefik
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-rbac.yaml

#setup secets and deploy traefik
echo -n 'gretler.tim@gmail.com' > /home/pi/username.txt
echo -n '$5' > /home/pi/api_token.txt
echo -n '$6' > /home/pi/aws_id.txt
echo -n '$7' > /home/pi/aws_secret.txt
kubectl create secret generic cloudfare-dns --namespace=kube-system --from-file=/home/pi/username.txt --from-file=/home/pi/api_token.txt
kubectl create secret generic aws --namespace=kube-system --from-file=/home/pi/aws_id.txt --from-file=/home/pi/aws_secret.txt
kubectl apply -f traefik_deamon.yaml
kubectl apply -f traefik_service.yaml
kubectl apply -f traefik_config.yaml

#deploy maetallb 
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl apply -f metallb_config.yaml

kubectl apply -f deployments.yaml
kubectl apply -f deployment_service.yaml
kubectl apply -f ingress.yaml