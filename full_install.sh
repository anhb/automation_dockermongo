#!/bin/bash
function docker_ubuntu {
   (apt-get update && echo -ne "[##..................] (10%)" && apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common ; 
   echo -ne "[####................] (20%)" && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && 
   add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && echo -ne "[##########..........] (50%)" && 
   apt-get update && echo -ne "[###############.....] (75%)" && apt-get install docker-ce docker-ce-cli containerd.io && echo -ne "[####################] (100%)" && return 0) || return 1
}

function docker_manjaro {
   (pacman -Syy && echo -ne "[#####...............] (25%)" &&
   pacman -S docker && echo -ne "[####################] (100%)" && return 0) || return 1
}

function docker_systemctl {
   (echo "initializing docker service" &&
   systemctl start docker &&
   systemctl enable docker &&
   echo "docker service started" && return 0) || (echo "error trying to start docker service" && return 1)
}

function docker_service {
   (echo "initializing docker service" &&
   service docker start &&
   service docker enable &&
   echo "docker service started" && return 0) || (echo "error trying to start docker service" && return 1)
}

function mongodb_install {
   (echo "Downloading mongodb docker image" && echo -ne "[#...................] (5%)" &&
   docker pull mongo && echo -ne "[#########...........] (45%)" &&
   echo "Creating directory" &&
   mkdir -p /mongodata && echo -ne "[###############.....] (75%)" &&
   echo "Running docker container" &&
   docker run -it -v mongodata:/data/db -p 27017:27017 --name mongodb -d mongo && echo -ne "[####################] (100%)" && return 0) || return 1
}

log_display {
   echo "==============================="
   echo "= DOCKER_INSTALLATION => $1   ="
   echo "= DOCKER_SERVICE => $2        ="
   echo "= MONGO_INSTALLATION => $3    ="
   echo "==============================="
}

OS=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
case $OS in
   ubuntu)
     echo "ubuntu process"
     echo "starting docker installation ......"
     if [ $(docker_ubuntu) == 0 ] ; then VALUE_DOCKER=True; else VALUE_DOCKER=False ; fi
     echo "starting service ......."
     if [ $(docker_service) == 0 ] ; then VALUE_SERVICE_TYPE=True; else VALUE_SERVICE_TYPE=False ; fi
     echo "starting mongo installation ........"
     if [ $(mongodb_install) == 0 ] ; then VALUE_MONGO=True; else VALUE_MONGO=False ; fi
     $(log_display VALUE_DOCKER VALUE_SERVICE_TYPE VALUE_MONGO)
     echo "Docker installation have finished"
     ;;
   manjaro)
     echo "manjaro process"
     echo "starting docker installation ......"
     f [ $(docker_manjaro) == 0 ] ; then VALUE_DOCKER=True; else VALUE_DOCKER=False ; fi
     echo "starting service ......."
     if [ $(docker_systemctl) == 0 ] ; then VALUE_SERVICE_TYPE=True; else VALUE_SERVICE_TYPE=False ; fi
     echo "starting mongo installation ........"
     if [ $(mongodb_install) == 0 ] ; then VALUE_MONGO=True; else VALUE_MONGO=False ; fi
     $(log_display VALUE_DOCKER VALUE_SERVICE_TYPE VALUE_MONGO)
     echo "Docker installation have finished"
     ;;
   *)
     echo "Distribution not supported"
     ;;
esac
