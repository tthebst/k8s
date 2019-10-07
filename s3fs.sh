#Arguments: <AWS ACCESS_KEY_ID> ,<SEECRET_ACCESS_KEY>
# This scripts should be run on the master node and installs s3fs on all worker nodes.

#install on master node
sudo apt-get install -y s3fs


sudo umount ../clusterdata/
sudo rm -r ../clusterdata/
ls -l ..
sudo rm -r /etc/fuse.conf
sudo cp ./fuse.conf /etc/
sudo rm ${HOME}/.passwd-s3fs
echo -n $1:$2 > ${HOME}/.passwd-s3fs
chmod 600 ${HOME}/.passwd-s3fs
mkdir ${HOME}/clusterdata
s3fs raspberrycluster ${HOME}/clusterdata -ouid=1001,gid=1001 -o umask=0000 -o allow_other -o passwd_file=${HOME}/.passwd-s3fs  -o url="https://s3-eu-central-1.amazonaws.com"
ls -l ..
sudo touch ../clusterdata/test1.txt;





scp ${HOME}/.passwd-s3fs pi@192.168.1.99:~/
scp ${HOME}/.passwd-s3fs pi@192.168.1.98:~/
scp ${HOME}/.passwd-s3fs pi@192.168.1.97:~/
scp ./fuse.conf pi@192.168.1.99:~/
scp ./fuse.conf pi@192.168.1.98:~/
scp ./fuse.conf pi@192.168.1.97:~/

ssh pi@192.168.1.99 'sudo apt-get install -y s3fs;sudo rm -r /etc/fuse.conf;sudo mv ~/fuse.conf /etc/;sudo umount ${HOME}/clusterdata;sudo rm -r clusterdata;chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/clusterdata;s3fs raspberrycluster ${HOME}/clusterdata -ouid=1001,gid=1001 -o umask=0000 -o allow_other -o passwd_file=${HOME}/.passwd-s3fs -o url="https://s3-eu-central-1.amazonaws.com";sudo touch ./clusterdata/test2.txt;exit'
ssh pi@192.168.1.98 'sudo apt-get install -y s3fs;sudo rm -r /etc/fuse.conf;sudo mv ~/fuse.conf /etc/;sudo umount ${HOME}/clusterdata;sudo rm -r clusterdata;chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/clusterdata;cat /etc/fuse.conf;s3fs raspberrycluster ${HOME}/clusterdata -ouid=1001,gid=1001 -o umask=0000 -o allow_other -o passwd_file=${HOME}/.passwd-s3fs -o url="https://s3-eu-central-1.amazonaws.com";sudo touch ./clusterdata/test3.txt;exit'
ssh pi@192.168.1.97 'sudo apt-get install -y s3fs;sudo rm -r /etc/fuse.conf;sudo mv ~/fuse.conf /etc/;sudo umount ${HOME}/clusterdata;sudo rm -r clusterdata;chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/clusterdata;s3fs raspberrycluster ${HOME}/clusterdata -ouid=1001,gid=1001 -o allow_other -o umask=0000-o passwd_file=${HOME}/.passwd-s3fs -o url="https://s3-eu-central-1.amazonaws.com";sudo touch ./clusterdata/test4.txt;exit'

