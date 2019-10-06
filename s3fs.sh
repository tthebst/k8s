#Arguments: <AWS ACCESS_KEY_ID> ,<SEECRET_ACCESS_KEY>
# This scripts should be run on the master node and installs s3fs on all worker nodes.

#install on master node
sudo apt-get install -y s3fs

echo $1:$2 > ${HOME}/.passwd-s3fs
sudo chmod 600 ${HOME}/.passwd-s3fs
mkdir ${HOME}/k8s_data
s3fs raspberrycluster ${HOME}/k8s_data -o passwd_file=${HOME}/.passwd-s3fs



ssh pi@192.168.1.99 'sudo apt-get install -y s3fs;echo -n  $1:$2 > ${HOME}/.passwd-s3fs;sudo chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/k8s_data;s3fs raspberrycluster ${HOME}/k8s_data -o passwd_file=${HOME}/.passwd-s3fse;exit'
ssh pi@192.168.1.98 'sudo apt-get install -y s3fs;echo -n  $1:$2 > ${HOME}/.passwd-s3fs;sudo chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/k8s_data;s3fs raspberrycluster ${HOME}/k8s_data -o passwd_file=${HOME}/.passwd-s3fse;exit'
ssh pi@192.168.1.97 'sudo apt-get install -y s3fs;echo -n  $1:$2 > ${HOME}/.passwd-s3fs;sudo chmod 600 ${HOME}/.passwd-s3fs;mkdir ${HOME}/k8s_data;s3fs raspberrycluster ${HOME}/k8s_data -o passwd_file=${HOME}/.passwd-s3fse;exit'

