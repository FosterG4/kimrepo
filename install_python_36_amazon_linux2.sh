#!/usr/bin/env bash

# A virtualenv running Python3.6 on Amazon Linux/EC2 (approximately) simulates the Python 3.6 Docker container used by Lambda
# and can be used for developing/testing Python 3.6 Lambda functions
# This script installs Python 3.6 on an EC2 instance running Amazon Linux and creates a virtualenv running this version of Python
# This is required because Amazon Linux does not come with Python 3.6 pre-installed
# and several packages available in Amazon Linux are not available in the Lambda Python 3.6 runtime

# The script has been tested successfully on a EC2 instance
# running 4.9.75-1.56.amzn2.x86_64
# and was developed with the help of AWS Support

# The steps in this script are:
# - install pre-reqs
# - install Python 3.6
# - create virtualenv

# install pre-requisites
sudo yum -y groupinstall development
sudo yum -y install zlib-devel
sudo yum -y install tk-devel
sudo yum -y install openssl-devel


# Installing openssl-devel alone seems to result in SSL errors in pip (see https://medium.com/@moreless/pip-complains-there-is-no-ssl-support-in-python-edbdce548852)
# Need to install OpenSSL also to avoid these errors
OPENSSL_VERSION=1_0_2l
OPENSSL_NAME=OpenSSL_${OPENSSL_VERSION}
wget https://github.com/openssl/openssl/archive/${OPENSSL_NAME}.tar.gz
tar -zxvf ${OPENSSL_NAME}.tar.gz
cd openssl-${OPENSSL_NAME}/

./config shared
make
sudo make install
export LD_LIBRARY_PATH=/usr/local/ssl/lib/

cd ..
rm ${OPENSSL_NAME}.tar.gz
rm -rf openssl-${OPENSSL_NAME}/


# Install Python 3.6
PYTHON_VERSION=3.6.9
PYTHON_NAME=Python-${PYTHON_VERSION}
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_NAME}.tar.xz
tar xJf ${PYTHON_NAME}.tar.xz
cd ${PYTHON_NAME}

./configure
make
sudo make install

cd ..
rm ${PYTHON_NAME}.tar.xz
sudo rm -rf ${PYTHON_NAME}


# Create virtualenv running Python 3.6
sudo yum install -y python2-pip
sudo pip install --upgrade virtualenv
virtualenv -p python3 py3env
source py3env/bin/activate

python --version
# Python ${PYTHON_VERSION}
