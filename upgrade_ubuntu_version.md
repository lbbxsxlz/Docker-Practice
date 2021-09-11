# upgrade ubuntu version
```bash
sudo apt update && sudo apt dist-upgrade && sudo apt autoremove
```
确保设置为Prompt=lts如果不是就修改为Prompt=lts
```bash
cat /etc/update-manager/release-upgrades
```
安装Ubuntu update manager
```bash
sudo apt install update-manager-core
```
开始升级
```bash
sudo do-release-upgrade 
```
接下来一路Y即可，整个过程大概需要一个多小时

