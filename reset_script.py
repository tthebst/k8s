from fabric import Connection
from invoke import Responder
import time

old_passwd = "##"
new_passwd = "##"
worker_pswd = "##"
master = Connection(host="pi@192.168.1.100", connect_kwargs={"password": old_passwd})
sudopass_master = Responder(pattern=r'\[sudo\] password:', response=new_passwd)

worker1 = Connection(host="pi@192.168.1.99", connect_kwargs={"password": worker_pswd})
worker2 = Connection(host="pi@192.168.1.98", connect_kwargs={"password": worker_pswd})
worker3 = Connection(host="pi@192.168.1.97", connect_kwargs={"password": worker_pswd})
print(master, worker1, worker2, worker3)
sudopass_worker = Responder(pattern=r'\[sudo\] password:', response=worker_pswd)

# Changing password of master
if old_passwd == "raspberry":
    r = master.run("echo -e \"%s\\n%s\\n%s\" | /usr/bin/passwd" % (old_passwd, new_passwd, new_passwd))
    print("==============")
    print("Changed password respnse:", r)
    print("==============")


# transfering setup files
for node in (master, worker1, worker2, worker3):
    print(node)
    r1 = node.put('hostname_and_ip.sh', remote='/home/pi/')
    print("HHH")
    r2 = node.put('install.sh', remote='/home/pi/')
    print("transfered files:", r1, r2)
    print("==============")

print("beginning setupof pis")
master.run("sudo sh hostname_and_ip.sh k8s-master 192.168.1.100 192.168.1.1", pty=True, watchers=[sudopass_master])
worker1.run("sudo sh hostname_and_ip.sh k8s-worker01 192.168.1.99 192.168.1.1", pty=True, watchers=[sudopass_worker])
worker2.run("sudo sh hostname_and_ip.sh k8s-worker02 192.168.1.98 192.168.1.1", pty=True, watchers=[sudopass_worker])
worker3.run("sudo sh hostname_and_ip.sh k8s-worker03 192.168.1.97 192.168.1.1", pty=True, watchers=[sudopass_worker])
master.run("sh install.sh", pty=True, watchers=[sudopass_master])
worker1.run("sh install.sh", pty=True, watchers=[sudopass_worker])
worker2.run("sh install.sh", pty=True, watchers=[sudopass_worker])
worker3.run("sh install.sh", pty=True, watchers=[sudopass_worker])
master.run("cat /boot/cmdline.txt", pty=True, watchers=[sudopass_master])
master.run("sudo sed -i.bck '$s/$/ cgroup_memory=1 cgroup_memory=memory/' /boot/cmdline.txt", pty=True, watchers=[sudopass_master])
master.run("sudo sh -c \"echo -n ' cgroup_memory=1 cgroup_memory=memory' >> /boot/cmdline.txt\"", pty=True, watchers=[sudopass_master])
master.run("cat /boot/cmdline.txt", pty=True, watchers=[sudopass_master])
print("==============")


print("rebooting")
master.run("sudo /sbin/reboot -f > /dev/null 2>&1 &", pty=True, watchers=[sudopass_master])
worker1.run("sudo /sbin/reboot -f > /dev/null 2>&1 &", pty=True, watchers=[sudopass_worker])
worker2.run("sudo /sbin/reboot -f > /dev/null 2>&1 &", pty=True, watchers=[sudopass_worker])
worker3.run("sudo /sbin/reboot -f > /dev/null 2>&1 &", pty=True, watchers=[sudopass_worker])
print("==============")

time.sleep(36)

print("init cluster")
res = None
while res is None:
    try:
        # connect
        master = Connection(host="pi@192.168.1.100", connect_kwargs={"password": old_passwd})
        result = master.run("sudo kubeadm init", pty=True, watchers=[sudopass_master])
        res = True
    except:
        print("restart pi's mauanlly")
        time.sleep(30)
        pass


join_string = input("put kubeadm join string here: ")
print(join_string)
print("==============")

print("master cluster seetup")
master.run("mkdir -p $HOME/.kube", pty=True, watchers=[sudopass_master])
master.run("sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config", pty=True, watchers=[sudopass_master])
master.run("sudo chown $(id -u):$(id -g) $HOME/.kube/config", pty=True, watchers=[sudopass_master])
print("==============")

print("Joining worker nodes")
worker1.run("sudo "+join_string, pty=True, watchers=[sudopass_worker])
worker2.run("sudo "+join_string, pty=True, watchers=[sudopass_worker])
worker3.run("sudo "+join_string, pty=True, watchers=[sudopass_worker])
print("==============")

print("set up waeve netowkr")
master.run("kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\"", pty=True, watchers=[sudopass_master])
print("==============")

master.run("kubectl get nodes")


print("FINISHED")
