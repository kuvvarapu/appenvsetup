#!/bin/bash
#Desc: This script is used instll nodejs ad pm2 lib and nginx and nodemodules


#1) Check for services
#2) If available skip installing
#3) If not install and start the services


#To check the services 
servicescheck(){


  nodeversion=`node -v`
  npmversion=`npm -v`
  pm2version=`pm2 -v`
  nginxcheck=`service --status-all|grep nginx|awk -F ' ' '{print $4}'`

 #node
  if [ -z $nodeversion ]
  then
     echo "Node not installed .Adding  node repository"
     curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
     installinodeservices
     if [ -f $(pwd)/package.json ]
     then
       npm install
     fi
  else
    echo "node version = "$nodeversion
    echo "npm version = "$npmversion
    echo "pm2 version = "$pm2version
  fi
  
  #nginx 
  if [ -z $nginxcheck ]
  then
    echo "nginx not installed .Going to install nginx"
    sudo apt-get install nginx -y
  else
    echo "nginx installed"

  fi

  #mysql 
 if [ -f /etc/init.d/mysql ]
 then
  echo "mysql installed"
 else
  echo "Mysql not installed. Going to install mysql"
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
#   mysqladmin -u root password 'sbi@onemoney'
   sudo /etc/init.d/mysql start
   sudo mysql -h127.0.0.1 -P3306 -uroot -e"UPDATE mysql.user SET password = PASSWORD('sbi@onemoney') WHERE user = 'root'"
fi 


}

installnodeservices(){

   sudo apt-get update
   sudo apt-get install nodejs
   npm install pm2 -g   

}

servicescheck
