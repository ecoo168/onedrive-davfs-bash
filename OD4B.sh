#!/bin/bash

LINE="---------------------------------------------------------"
clear
echo "${LINE}"
echo "      挂载onedrive企业版到海纳思系统        "
echo "                             By 神雕       "
echo "${LINE}"
echo " "

echo "请输入企业版onedrive我的文件的地址, 例如：'https://****-my.sharepoint.com/personal/name_domain_com/Documents/test'"
read OD4B
echo " "
echo " "
echo "${LINE}"
echo "The OD4B Link:"
echo "${OD4B}"
echo "${LINE}"
echo " "
echo " "
echo " "


echo "请输入挂载的绝对路径, e.g. '/onedrive'"
read MPATH
if [ ! -d "${MPATH}" ]
then
  sudo mkdir -p ${MPATH}
fi
echo " "
echo " "
echo "${LINE}"
echo "挂载路径是:"
echo "${MPATH}"
echo "${LINE}"
echo " "
echo " "
echo " "


echo "请输入onedrive邮箱账号, e.g. 'user@domain.edu'"
read USERNAME
echo " "
echo " "
echo "${LINE}"
echo "The USERNAME:"
echo "${USERNAME}"
echo "${LINE}"
echo " "
echo " "
echo " "



echo "请输入onedrive密码:"
read PASSWORD
echo " "
echo " "
echo "${LINE}"
echo "The PASSWORD:"
echo "${PASSWORD}"
echo "${LINE}"
echo " "
echo "按任意键开始配置和挂载"
read


sudo apt-get update && sudo apt-get install -y davfs2 wget python

if [ ! -f "/etc/davfs2/davfs2.conf" ]
then 
sudo touch /etc/davfs2/davfs2.conf
fi
sudo chmod 777 /etc/davfs2/davfs2.conf
echo >> /etc/davfs2/davfs2.conf
echo >> /etc/davfs2/davfs2.conf

wget https://raw.hisi.ga/ecoo168/onedrive-davfs-bash/master/get-sharepoint-auth-cookie.py
python get-sharepoint-auth-cookie.py ${OD4B} ${USERNAME} ${PASSWORD} > cookie.txt
sed -i "s/ //g" cookie.txt
COOKIE=$(cat cookie.txt)
DAVFS_CONFIG=$(grep -i "use_locks 0" /etc/davfs2/davfs2.conf)
if [ "${DAVFS_CONFIG}" == "use_locks 0" ] 
then
  echo "continue..."
else
  echo "use_locks 0" >> /etc/davfs2/davfs2.conf
fi
echo "[${MPATH}]" >> /etc/davfs2/davfs2.conf
echo "add_header Cookie ${COOKIE}" >> /etc/davfs2/davfs2.conf

rm cookie.txt get-sharepoint-auth-cookie.py

sudo /sbin/mount.davfs ${OD4B} ${MPATH}
