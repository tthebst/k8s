# k8s

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
-newest k8s installed with overlay snetwork