





#connect to worker1 and add localfs to exports
ssh 192.168.1.97 'sudo apt-get install exfat-fuse exfat-utils;sudo apt-get install exportfs;sudo cat "/home/pi/localfs            192.168.1.98(rw)"> /etc/exports;sudo cat "/home/localfs            192.168.1.99(rw)"> /etc/exports;sudo cat "/home/localfs            192.168.1.100(rw)"> /etc/exports;exportfs -r;exportfs'
