#!/bin/bash

cd /opt/
echo "$(tput setaf 1)install depedencies$(tput sgr 0)"
# install depedencies
 yum -y install binutils compat-libcap1 gcc gcc-c++ glibc glibc.i686 glibc-devel glibc.i686 ksh libaio libaio.i686 libaio-devel libaio-devel.i686 libgcc libgcc.i686 libstdc++ libstdc++l7.i686 libstdc++-devel libstdc++-devel.i686 compat-libstdc++-33 compat-libstdc++-33.i686 libXi libXi.i686 libXtst libXtst.i686 make sysstat
echo "$(tput setaf 1)add repo javasdk$(tput sgr 0)"
# add repo javasdk
curl -s "https://get.sdkman.io" | bash
source "/root/.sdkman/bin/sdkman-init.sh"
sdk install java 8.0.265-open
readlink -f $(which java)
echo "$(tput setaf 1)get oracle database repo$(tput sgr 0)"
# get oracle database repo
curl http://public-yum.oracle.com/public-yum-ol7.repo -o /etc/yum.repos.d/public-yum-ol7.repo
echo "$(tput setaf 1)enable oracle database repo$(tput sgr 0)"
# enable oracle database repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/public-yum-ol7.repo
rpm --import http://yum.oracle.com/RPM-GPG-KEY-oracle-ol7
echo "$(tput setaf 1)download oracle rpm$(tput sgr 0)"
# download oracle rpm
cd /opt/
wget http://mrg.southeastasia.cloudapp.azure.com/cfg/oracle/oracle-database-ee-19c-1.0-1.x86_64.rpm /opt/oracle-database-ee-19c-1.0-1.x86_64.rpm
echo "$(tput setaf 1)install oracle database preinstall$(tput sgr 0)"
# install oracle database preinstall
yum --enablerepo=ol7_latest -y install oracle-database-preinstall-19c
rpm -Uvh oracle-database-ee-19c-1.0-1.x86_64.rpm
echo "$(tput setaf 1)create oracle listener$(tput sgr 0)"
# create oracle listener
touch /etc/sysconfig/oracledb_ORCLCDB-19c.conf
echo -e "\
LISTENER_PORT=1521 \n\
echo ORACLE_DATA_LOCATION=/opt/oracle/oradata \n\
echo EM_EXPRESS_PORT=5500 \
" > /etc/sysconfig/oracledb_ORCLCDB-19c.conf
echo "$(tput setaf 1)configure oracle$(tput sgr 0)"
# configure oracle
/etc/init.d/oracledb_ORCLCDB-19c configure
echo "$(tput setaf 1)add bash_profile$(tput sgr 0)"
# add bash_profile
echo -e "\
umask 022 \n\
export ORACLE_SID=ORCLCDB \n\
export ORACLE_BASE=/opt/oracle/oradata \n\
export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1 \n\
export PATH=$PATH:$ORACLE_HOME/bin \
" > ~/.bash_profile
echo "$(tput setaf 1)add define environment$(tput sgr 0)"
# add define environment
touch /etc/sysconfig/ORCLCDB.oracledb
echo -e "\
ORACLE_BASE=/opt/oracle/oradata \n\
ORACLE_HOME=/opt/oracle/product/19c/dbhome_1 \n\
ORACLE_SID=ORCLCDB \
" >/etc/sysconfig/ORCLCDB.oracledb
echo "$(tput setaf 1)add listener service$(tput sgr 0)"
# add listener service
touch /usr/lib/systemd/system/ORCLCDB@lsnrctl.service
echo -e "\
[Unit] \n\
Description=Oracle Net Listener \n\
After=network.target \n\
\n\
[Service] \n\
Type=forking \n\
EnvironmentFile=/etc/sysconfig/ORCLCDB.oracledb \n\
ExecStart=/opt/oracle/product/19c/dbhome_1/bin/lsnrctl start \n\
ExecStop=/opt/oracle/product/19c/dbhome_1/bin/lsnrctl stop \n\
User=oracle \n\
\n\
[Install] \n\
WantedBy=multi-user.target \n\
" >/usr/lib/systemd/system/ORCLCDB@lsnrctl.service
echo "$(tput setaf 1)add service database$(tput sgr 0)"
# add service database
touch /usr/lib/systemd/system/ORCLCDB@oracledb.service
echo -e "\
[Unit] \n\
Description=Oracle Database service \n\
After=network.target lsnrctl.service \n\
\n\
[Service] \n\
Type=forking \n\
EnvironmentFile=/etc/sysconfig/ORCLCDB.oracledb \n\
ExecStart=/opt/oracle/product/19c/dbhome_1/bin/dbstart $ORACLE_HOME \n\
ExecStop=/opt/oracle/product/19c/dbhome_1/bin/dbshut $ORACLE_HOME \n\
User=oracle \n\
\n\
[Install] \n\
WantedBy=multi-user.target \n\
" > /usr/lib/systemd/system/ORCLCDB@oracledb.service
echo "$(tput setaf 1)reload service$(tput sgr 0)"
# reload service
systemctl daemon-reload
systemctl enable ORCLCDB@lsnrctl ORCLCDB@oracledb