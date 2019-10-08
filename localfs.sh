




scp ./exports 192.168.1.97:~/
#connect to worker1 and add localfs to exports
ssh 192.168.1.97 'sudo apt-get install exfat-fuse exfat-utils;sudo apt install nfs-kernel-server;sudo rm /etc/exports;sudo mv ./exports /etc/exports;sudo exportfs -r;sudo exportfs'
mkdir ~/localfs  
sudo mount 192.168.1.97:/home/pi/localfs ~/localfs
echo '192.168.1.97:/home/pi/localfs ~/localfs    nfs rw 0 0' >>sudo /etc/fstab
ssh 192.168.1.98 'mkdir ~/localfs ;sudo mount 192.168.1.97:/home/pi/localfs ~/localfs;echo "192.168.1.97:/home/pi/localfs ~/localfs    nfs rw 0 0" >>sudo /etc/fstab'
ssh 192.168.1.99 'mkdir ~/localfs ;sudo mount 192.168.1.97:/home/pi/localfs ~/localfs;echo "192.168.1.97:/home/pi/localfs ~/localfs    nfs rw 0 0" >>sudo /etc/fstab'
mount -t nfs

