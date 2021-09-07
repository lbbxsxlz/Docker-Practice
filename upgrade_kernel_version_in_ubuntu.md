# upgrade kernel version
## upgrade kernel
from  4.4.0-169-generic
to    4.15.18-041518-generic


ubuntu kernel [list](https://kernel.ubuntu.com/~kernel-ppa/mainline/)
```bash
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.15.18/linux-headers-4.15.18-041518_4.15.18-041518.201804190330_all.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.15.18/linux-headers-4.15.18-041518-generic_4.15.18-041518.201804190330_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.15.18/linux-image-4.15.18-041518-generic_4.15.18-041518.201804190330_amd64.deb

sudo dpkg -i linux-headers-4.15.18-041518_4.15.18-041518.201804190330_all.deb
sudo dpkg -i linux-headers-4.15.18-041518-generic_4.15.18-041518.201804190330_amd64.deb
sudo dpkg -i linux-image-4.15.18-041518-generic_4.15.18-041518.201804190330_amd64.deb
```

## upgrade nvidia driver
close X windows
```bash
sudo service lightdm stop
```

remove nvidia driver
```bash
sudo apt-get purge nvidia*
sudo apt-get purge autoremove
sudo apt-get autoremove
sudo ./NVIDIA-Linux-x86_64-430.09.run --uninstall
```

no nouveau driver
```bash
cat /etc/modprobe.d/blacklist.conf 
lsmod | grep nouveau
```

install latest driver
```bash
chmod +x NVIDIA-Linux-x86_64-470.63.01.run
sudo ./NVIDIA-Linux-x86_64-470.63.01.run -no-x-check -no-nouveau-check -no-opengl-files

reboot
```

