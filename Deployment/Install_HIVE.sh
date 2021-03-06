#!/usr/bin/env bash

echo "
####\    ####\   ####\  ###\          ###\  ############|
#### |   #### |  #### | ### \         ###|  ############|
#### |   #### |  #### |  ### \       ### /  #### |
############# |  #### |   ### \     ### /   #### |
############# |  #### |    ### \   ### /    ############|
#### |   #### |  #### |     ### \ ### /     #### |
#### |   #### |  #### |      ### ### /      #### |
#### |   #### |  #### |       ##### /       ############|
####/    ####/   ####/         ###_/        ############/

HIVE application is created by FOUR.

This Quick Start script installs all prerequisites needed in order to run HIVE succesfully. 

This script will install some prerequisites on your system, it does not check whether the installed packages already exist or not. FOUR. is not responsible for any damage this script may cause for your system

Do you want to continue? (y/n)
"

read input

# If the user agrees with the agreement, the script will start installing. 
# The user is able to abort the installation for 10 seconds after confirming, this
# 10 second period cannot be skipped.
if [ "$input" = y ] ; then

secs=$((10))
while [ $secs -gt 0 ]; do
	echo -ne "$secs\033[0K\rRemaining seconds before start: "
	sleep 1
	: $((secs--))
done

echo "
Installing Python 3.6 - PIP - Packages
"

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install python3.6 -y
sudo apt-get install python3.6-dev -y
sudo apt-get install python3.6-venv -y

wget https://bootstrap.pypa.io/get-pip.py
sudo python3.6 get-pip.py
rm get-pip.py

pip3 install -r Requirements/requirements.txt

echo "
Installed: Python 3.6 - PIP - Packages
"


# Installing database MySQL
apt-get -y remove --purge mysql-server-5.5
apt-get -y autoremove

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
echo "mysql-server-5.6 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password root" | debconf-set-selections
apt-get -y install mysql-server-5.6

mysql -u root -proot <<MY_QUERY
CREATE SCHEMA scotchbox;
MY_QUERY
echo "Database scotchbox created"

# mysql -u root -proot <<MY_QUERY
# USE scotchbox;
# ALTER TABLE scotchbox.content ADD FULLTEXT (content);
# ALTER TABLE scotchbox.content ADD FULLTEXT (content);
# MY_QUERY

echo "Full-Text Search enabled"

# Install Circus
sudo apt-get install libzmq-dev libevent-dev python-dev python-virtualenv -y

virtualenv /opt/HIVE
cd /opt/HIVE
bin/pip install circus

# Install ZeroMQ

wget http://download.zeromq.org/zeromq-4.0.5.tar.gz

tar xvzf zeromq-4.0.5.tar.gz

sudo apt-get update && \
sudo apt-get install -y libtool pkg-config build-essential autoconf automake uuid-dev

cd zeromq-4.0.5

./configure

sudo make install

sudo ldconfig

ldconfig -p | grep zmq

# Install TOR
sudo echo "deb http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
sudo echo "deb-src http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list

sudo gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
sudo gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

sudo apt-get update -y

sudo apt-get install tor deb.torproject.org-keyring -y
echo "
Cleaning up some files..."

echo "
####\    ####\   ####\  ###\          ###\  ############|
#### |   #### |  #### | ### \         ###|  ############|
#### |   #### |  #### |  ### \       ### /  #### |
############# |  #### |   ### \     ### /   #### |
############# |  #### |    ### \   ### /    ############|
#### |   #### |  #### |     ### \ ### /     #### |
#### |   #### |  #### |      ### ### /      #### |
#### |   #### |  #### |       ##### /       ############|
####/    ####/   ####/         ###_/        ############/

HIVE and all of it's prerequisites are succesfully installed. Start HIVE by navigating to the directory and starting the HIVE.sh bash script. 

"

echo "Exiting now"

                   exit 1
                else
                    echo "Exiting Quick Start."
                    exit 1
                fi
            ;;