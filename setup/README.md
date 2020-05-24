# K8S PROJECT


### Ansible 

You can setup your cluster with Ansible. Install rasbian on each raspberry and clone following [repo](https://github.com/rak8s/rak8s)
```
git clone git@github.com:rak8s/rak8s.git
```
First you need to distribute the keys
```
cd setup
ansible-playbook -i hosts.ini distribute-key.yml --user=pi  --ask-pass
```
Second run ansible script frome cloned repo:
```
cd rak8s
ansible-playbook cleanup.yml
ansible-playbook cluster.yml
```


On Masternode copy kubecofnig to home folder 
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```