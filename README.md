# K8S PROJECT

![alt text](https://github.com/tthebst/k8s/blob/master/image_of_cluster.jpeg "Logo Title Text 1")



**Currently running on cluster:**
- www.stockbuilder.ch
- www.speechgroup.ch

### HOW TO START

This is the configuration of my home raspberry pi k8s cluster.

If you want so use this start with the reset_script.py python script.
This script should be run on your designated master node. Currently script supports 3 worker nodes and 1 master node.

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
echo -n 'gretler.tim@gmail.com' > ./k8s/username.txt
echo -n '***********************' > ./k8s/api_token.txt
kubectl create secret generic cloudfare-dns --namespace=kube-system --from-file=./k8s/username.txt --from-file=./k8s/api_token.txt
kubectl apply -f traefik_deamon.yaml
kubectl apply -f traefik_service.yaml
kubectl apply -f traefik_config.yaml
```
This includes configs for dns certifcation from cloudfare (where the dns of my website is located) and rediraction to https.

Finally we need to create an metal load balancer, because we are running kubernetes on bare metal. I'm using metallb. This will assign an local IP to the traefik loadbalancing service. Just run the following commands.
```
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
kubectl apply -f metallb_config.yaml
```

We now need to still deploy a actual service. Following command will deploy [my stockpicker app](https://github.com/tthebst/stock_picker) and create a service.

```
kubectl apply -f test.yaml
kubectl apply -f test_service.yaml
```

Finally we can deploy the actual kubernetes traefik ingress which routes the traffic to the corresponding service pod. 
```
kubectl apply -f ingress.yaml
```


The services served by the loadbalancer can now be accessed inside your local network and with the correct router and DNS setup also from outside.


