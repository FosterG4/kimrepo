#============================================================================================================
echo "$(tput setaf 1)install mariadb 10.1$(tput sgr 0)"
echo "=============================================================================================="
sleep 7

# add repo mariadb
cd ~/
cp /opt/kimrepo/asset/MariaDB.repo /etc/yum.repos.d/MariaDB.repo

#install mariadb
yum install boost-devel.x86_64 socat MariaDB-server MariaDB-client MariaDB-compat galera socat jemalloc rsync galera -y
sleep 2

# start & auto start mariadb
systemctl start mariadb && systemctl enable mariadb
echo "$(tput setaf 1)selesai$(tput sgr 0)"
echo "=============================================================================================="
sleep 7
