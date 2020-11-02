#!/bin/bash

BLUE="$(tput setaf 4)"
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
NC="$(tput setaf 9)"

function docker_ubuntu {
   ( set -x; apt-get update ) && echo -ne "\n${RED}[##..................] ${BLUE}(10%)${NC}\n";
   ( set -x; apt-get --assume-yes install apt-transport-https ca-certificates curl gnupg-agent software-properties-common ) && echo -ne "\n${RED}[####................] ${BLUE}(20%)${NC}\n";
   ( set -x; curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -y - &&
   add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" ) && echo -ne "\n${RED}[##########..........] ${BLUE}(50%)${NC}\n";
   ( set -x; apt-get update ) && echo -ne "\n${RED}[###############.....] ${BLUE}(75%)${NC}\n" && ( set -x; apt-get --assume-yes install docker-ce docker-ce-cli containerd.io ) && echo -ne "\n${GREEN}[####################] ${BLUE}(100%)${NC}\n" && return 0 || return 1
}

function docker_manjaro {
   ( set -x; pacman -Syy );
   echo -ne "\n${RED}[#####...............] ${BLUE}(25%)${NC}\n";
   ( set -x; pacman -S docker --noconfirm ) && echo -ne "\n${GREEN}[####################] ${BLUE}(100%)${NC}\n" && return 0 || return 1;
}

function docker_systemctl {
   ( set -x; systemctl start docker && systemctl enable docker ) && echo -ne "docker service started${NC}" && return 0 || return 1;
}

function docker_service {
   ( set -x; service docker start ) && echo -ne "docker service started${NC}" && return 0 || return 1;
}

function mongodb_install {
   echo -ne "${BLUE}Downloading mongodb docker image${NC}";
   echo -ne "\n${RED}[#...................] (5%)${NC}\n";
   ( set -x; docker pull mongo );
   echo -ne "\n${RED}[#########...........] (45%)${NC}\n";
   echo -ne "${BLUE}Creating directory${NC}";
   ( set -x; mkdir -p /mongodata ) && echo -ne "\n${RED}[###############.....] ${BLUE}(75%)${NC}\n";
   echo -ne "${BLUE}Running docker container${NC}";
   ( set -x; docker run -it -v mongodata:/data/db -p 27017:27017 --name mongodb -d mongo ) && echo -ne "\n${GREEN}[####################] ${BLUE}(100%)${NC}\n" && return 0 || return 1;
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
     clear
     echo "${BLUE}ubuntu process${NC}"
     echo "${BLUE}starting docker installation ......${NC}"
     docker_ubuntu
     VALUE_DOCKER=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "${BLUE}starting service .......${NC}"
     docker_service
     VALUE_SERVICE_TYPE=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "${BLUE}starting mongo installation ........${NC}"
     mongodb_install
     VALUE_MONGO=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     log_display $VALUE_DOCKER $VALUE_SERVICE_TYPE $VALUE_MONGO
     echo "${BLUE}Docker installation have finished${NC}"
     ;;
   manjaro)
     clear
     echo "${BLUE}manjaro process${NC}"
     echo "${BLUE}starting docker installation ......${NC}"
     docker_manjaro
     VALUE_DOCKER=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "${BLUE}starting service .......${NC}"
     docker_systemctl
     VALUE_SERVICE_TYPE=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     echo "${BLUE}starting mongo installation ........${NC}"
     mongodb_install
     VALUE_MONGO=$(if [ $? -eq 0 ] ; then echo "True"; else echo "False" ; fi)
     log_display $VALUE_DOCKER $VALUE_SERVICE_TYPE $VALUE_MONGO
     echo "${BLUE}Docker installation have finished${NC}"
     ;;
   *)
     echo "${RED}Distribution not supported${NC}"
     ;;
esac
