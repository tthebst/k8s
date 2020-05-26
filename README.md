# K8S PROJECT

![alt text](https://github.com/tthebst/k8s/blob/master/image_of_cluster.jpeg "Logo Title Text 1")

### Ansible setup 

**=========THIS IS THE CURRENT WAY TO STUP K8S ON RPI=========**


You can setup your cluster with Ansible. You only need ansible and the IP's of the raspberries. [SETUP GUIDE](https://github.com/tthebst/k8s/tree/master/setup)

**============================================================**

### BTC Node

You can run a Bitcoin node on your cluster with following command. You first create a volume clain which is then used by the bitcoin node to store the blockchain data.
```
kubectl apply -f bts/pv-claim.yml
kubectl apply -f bts/btc-deploy.yml
kubectl apply -f bts/btc-service.yml
```



### Dashboard

To get the kubernetes dashboard run the following command:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml

kubectly apply -f rbac.yaml
kubectl proxy &
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep my-user | awk '{print $1}')
```

Now copy the token printed in the console by the last command and visit(http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default). If you want to access the cluster from outside use portforwarding to connect to the masternode:
```
ssh -L  localhost:8001:localhost:8001 pi@192.168.1.100
```


















### HOW TO START

**=========OLD WAY TO SETUP RPI=========**


This is the configuration of my home raspberry pi k8s cluster.

If you want so use this start with the reset_script.py python script.
This script should be run on your local machine and will connect to all nodes. Currently script supports 3 worker nodes and 1 master node.

```
python3 <new masternode password> <current ip of master node> <current ip worker 1> <current ip of worker 2> <current ip of worker 3>
```

You may need to restart the cluster manually by switching it on and off, because of some cgroup issues. 
Now you have the following configuration:

-ip master: 192.168.1.100

-ip worker1: 192.168.1.99

-ip worker2: 192.168.1.98

-ip worker3: 192.168.1.97

-newest k8s installed with overlay network

### LOADBALANCING AND TEST SERVICE

As a application level loadbalancer I deployed traefik. For refrence check traefik.io

First we need to apply RBAC.
```
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-rbac.yaml
```
Now we need to deploy the actual load balancer as a Deamonset to run on all nodes.
```
echo -n 'gretler.tim@gmail.com' > /home/pi/username.txt
echo -n '***********************' > /home/pi/api_token.txt
kubectl create secret generic cloudfare-dns --from-file=./k8s/username.txt --from-file=./k8s/api_token.txt
kubectl apply -f ./traefik/traefik_deamon.yaml
kubectl apply -f ./traefik/traefik_service.yaml
kubectl apply -f ./traefik/traefik_config.yaml
```
This includes configs for dns acme certifcation from cloudfare (where the dns of my website is located) and rediraction to https.

Finally we need to create an metal load balancer, because we are running kubernetes on bare metal. I'm using metallb. This will assign an local IP to the traefik loadbalancing service. Just run the following commands. The last command show the currently running services and we see the exposed IP. 
```
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl apply -f ./metallb/metallb_config.yaml
kubectl get svc
```

We now need to still deploy an actual service. Following command will deploy [my stockpicker app](https://github.com/tthebst/stock_picker), [my personal website](https://github.com/tthebst/personal_website) and my groupproject. The second command will create a service for these deployments.

```
kubectl apply -f deployments.yaml
kubectl apply -f deployment_service.yaml
```

Finally we can deploy the actual kubernetes traefik ingress which routes the traffic to the corresponding service pod. 
```
kubectl apply -f ingress.yaml
```


The services served by the loadbalancer can now be accessed inside your local network and with the correct router and DNS setup also from outside.



### Cronjob

Follow the instruction from [this post](https://stackoverflow.com/questions/38391412/raspberry-pi-send-mail-from-command-line-using-gmail-smtp-server)! Now you're able to send mails from the raspberry pi master node. Add following line to /etc/crontab
```
0  *    * * *   root    sh /home/pi/k8s/cronjobs/cronjob.sh 
```
