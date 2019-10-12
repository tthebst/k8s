# K8S PROJECT

![alt text](https://github.com/tthebst/k8s/blob/master/image_of_cluster.jpeg "Logo Title Text 1")



**Currently running on cluster:**
- www.stockbuilder123.ch
- www.speechgroup.ch
- www.timgretler.ch

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
echo -n 'gretler.tim@gmail.com' > /home/pi/username.txt
echo -n '***********************' > /home/pi/api_token.txt
kubectl create secret generic cloudfare-dns --from-file=./k8s/username.txt --from-file=./k8s/api_token.txt
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

We now need to still deploy a actual service. Following command will deploy [my stockpicker app](https://github.com/tthebst/stock_picker), [my personal website](https://github.com/tthebst/stock_picker) and my groupproject. The second command will create a service for these deployments.

```
kubectl apply -f deployments.yaml
kubectl apply -f deployment_service.yaml
```

Finally we can deploy the actual kubernetes traefik ingress which routes the traffic to the corresponding service pod. 
```
kubectl apply -f ingress.yaml
```


The services served by the loadbalancer can now be accessed inside your local network and with the correct router and DNS setup also from outside.

### Storage

Storage is somewhat difficult on kubernetes because of two reasons. First containers generally should be stateless and second kubernetes is cloud native so a lot of solution are not comptible with a local kubernetes cluster.



~~To workaround these problems I will use AWS s3 storage as a filesystem with s3fs. This isn't optimal because s3 isn't intended to be used that way and a all sorts of problems can arise like race conditions and inconsistency. So to try to avoid these problems I will only deploy one pod that write to a certain s3 location. The script s3fs installs all s3fs on all nodes and should be run on the master node but requires that the master ssh-key is in .ssh/authorized_keys in each worker node. Now we can run these commands to deploy a bitcoin node.~~ Costs are too high to run filesystem on s3 too much sync.



So we will go for a local solution. To mount the local filesystem we need e hardrive(exfat) and attach it to a worker node (my case worker3). We need to run the following script on the masternode. This will make the harddrive available to all nodes on /home/pi/localfs.

```
sh localfs.sh
```
This isn't optimal because the local mounted filesystem isn't intended to be used that way and a all sorts of problems can arise like race conditions and inconsistency. So to try to avoid these problems I will only deploy one pod that write to a certain local harddrive location. Now we can deploy a bitcoin full node with the following command which will write the blockchain data to the local harddrive.
```
kubectly apply -f btc-service.yaml

kubectly apply -f btc-deploy.yaml
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

### Cronjob

Run following command to start a cronjob which checks if websites are still reachable. If not it will send a email to me. 
```
kubectl apply -f cronjob.yaml
```