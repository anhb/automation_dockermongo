#!/bin/bash

BLUE='\033[0;34m\]'
GREEN='\033[0;32m\]'
RED='\033[0;31m\]'
WHITE='\033[0;37m\]'
NC='\033[0m\]'

function docker_ubuntu {
   ( set -x; apt-get update ) && echo -ne "\n[##..................] (10%)\n";
   ( set -x; apt-get --assume-yes install apt-transport-https ca-certificates curl gnupg-agent software-properties-common ) && echo -ne "\n[####................] (20%)\n";
   ( set -x; curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -y - &&
   add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" ) && echo -ne "\n[##########..........] (50%)\n";
   ( set -x; apt-get update ) && echo -ne "\n[###############.....] (75%)\n" && ( set -x; apt-get --assume-yes install docker-ce docker-ce-cli containerd.io ) && echo -ne "\n[####################] (100%)\n" && return 0 || return 1
}

function docker_manjaro {
   ( set -x; pacman -Syy );
   echo -ne "\n[#####...............] (25%)\n";
   ( set -x; pacman -S docker --noconfirm ) && echo -ne "\n[####################] (100%)\n" && return 0 || return 1;
}

function docker_systemctl {
   ( set -x; systemctl start docker && systemctl enable docker ) && echo -ne "docker service started" && return 0 || return 1;
}

function docker_service {
   ( set -x; service docker start ) && echo -ne "docker service started" && return 0 || return 1;
}

function mongodb_install {
   echo -ne "Downloading mongodb docker image";
   echo -ne "\n[#...................] (5%)\n";
   ( set -x; docker pull mongo );
   echo -ne "\n[#########...........] (45%)\n";
   echo -ne "Creating directory";
   ( set -x; mkdir -p /mongodata ) && echo -ne "\n[###############.....] (75%)\n";
   echo -ne "Running docker container";
   ( set -x; docker run -it -v mongodata:/data/db -p 27017:27017 --name mongodb -d mongo ) && echo -ne "\n[####################] (100%)\n" && return 0 || return 1;
}

function log_display {
   echo "==================================";
   echo "= DOCKER_INSTALLATION => $1   =";
   echo "= DOCKER_SERVICE => $2        =";
   echo "= MONGO_INSTALLATION => $3    =";
   echo "=================================="
}

OS=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
case $OS in
   ubuntu)
     echo "ubuntu process"
     echo "starting docker installation ......"
     docker_ubuntu
     VALUE_DOCKER=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "starting service ......."
     docker_service
     VALUE_SERVICE_TYPE=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "starting mongo installation ........"
     mongodb_install
     VALUE_MONGO=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     log_display $VALUE_DOCKER $VALUE_SERVICE_TYPE $VALUE_MONGO
     echo "Docker installation have finished"
     ;;
   manjaro)
     echo "manjaro process"
     echo "starting docker installation ......"
     docker_manjaro
     VALUE_DOCKER=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "starting service ......."
     docker_systemctl
     VALUE_SERVICE_TYPE=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "starting mongo installation ........"
     mongodb_install
     VALUE_MONGO=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     log_display $VALUE_DOCKER $VALUE_SERVICE_TYPE $VALUE_MONGO
     echo "Docker installation have finished"
     ;;
   *)
     echo "Distribution not supported"
     ;;
esac
