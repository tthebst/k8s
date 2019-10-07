#Arguments: <AWS ACCESS_KEY_ID> ,<SEECRET_ACCESS_KEY>
# This scripts should be run on the master node and installs s3fs on all worker nodes.

#install on master node
sudo apt-get install -y s3fs


sudo umount ../clusterdata/
sudo rm -r ../clusterdata/
sudo rm ${HOME}/.passwd-s3fs
echo -n $1:$2 > ${HOME}/.passwd-s3fs
chmod 600 ${HOME}/.passwd-s3fs
mkdir ${HOME}/clusterdata
s3fs raspberrycluster ${HOME}/clusterdata -o passwd_file=${HOME}/.passwd-s3fs  -o url="https://s3-eu-central-1.amazonaws.com"

scp ${HOME}/.passwd-s3fs pi@192.168.1.99:~/
scp ${HOME}/.passwd-s3fs pi@192.168.1.98:~/
scp ${HOME}/.passwd-s3fs pi@192.168.1.97:~/


ssh pi@192.168.1.99 'sudo apt-get install -y s3fs;sudo umount clusterdata/;sudo rm -r clusterdata;chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/clusterdata;s3fs raspberrycluster ${HOME}/clusterdata -o allow_other -o passwd_file=${HOME}/.passwd-s3fs -o url="https://s3-eu-central-1.amazonaws.com";exit'
ssh pi@192.168.1.98 'sudo apt-get install -y s3fs;sudo umount clusterdata/;sudo rm -r clusterdata;chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/clusterdata;s3fs raspberrycluster ${HOME}/clusterdata -o allow_other -o passwd_file=${HOME}/.passwd-s3fs -o url="https://s3-eu-central-1.amazonaws.com";exit'
ssh pi@192.168.1.97 'sudo apt-get install -y s3fs;sudo umount clusterdata/;sudo rm -r clusterdata;chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/clusterdata;s3fs raspberrycluster ${HOME}/clusterdata -o allow_other -o passwd_file=${HOME}/.passwd-s3fs -o url="https://s3-eu-central-1.amazonaws.com";exit'

