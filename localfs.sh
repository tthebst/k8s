




scp ./exports 192.168.1.99:~/
#connect to worker1 and add localfs to exports
ssh 192.168.1.99 'mkdir /home/pi/localfs;sudo mount /dev/sda1  /home/pi/localfs;sudo apt-get install exfat-fuse exfat-utils;sudo apt install nfs-kernel-server;sudo rm /etc/exports;sudo mv ./exports /etc/exports;sudo exportfs -r;sudo exportfs;echo "/dev/sda1  /home/pi/localfs   exfat-fuse rw 0 0" >>sudo /etc/fstab'


#install exfat utilities on master and other worker nodes
mkdir ~/localfs 
sudo sudo apt-get install exfat-fuse exfat-utils
sudo umount ~/localfs
sudo mount 192.168.1.99:/home/pi/localfs ~/localfs
echo '192.168.1.99:/home/pi/localfs ~/localfs    exfat-fuse rw 0 0' >>sudo /etc/fstab
ssh 192.168.1.98 'sudo sudo apt-get install exfat-fuse exfat-utils;mkdir ~/localfs ;sudo umount ~/localfs;sudo mount 192.168.1.99:/home/pi/localfs ~/localfs;echo "192.168.1.99:/home/pi/localfs ~/localfs    exfat-fuse rw 0 0" >>sudo /etc/fstab'
ssh 192.168.1.97 'sudo sudo apt-get install exfat-fuse exfat-utils;mkdir ~/localfs ;sudo umount ~/localfs;sudo mount 192.168.1.99:/home/pi/localfs ~/localfs;echo "192.168.1.99:/home/pi/localfs ~/localfs    exfat-fuse rw 0 0" >>sudo /etc/fstab'
mount -t nfs
sudo cat /etc/fstab
