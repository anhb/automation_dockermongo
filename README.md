# Automation Docker and MongoDB



## Description

These project automate the docker and mongodb container installation on Linux. Only exists support for Ubuntu and Manjaro. The repository contains next 2 files:

1. full_install.sh (Install Docker and MongoDB Container)

2. mongodb_container_install.sh (Install MongoDB Container)

   

## Installation

To run a script you must execute it using **sudo** command

`$ sudo ./full_install.sh`

`$ sudo ./mongodb_container_install.sh`



### Issues

If the script goes down because of permission error you must grant permissions to the files

`# chmod +x full_install.sh`

`# chown your_user:your_user full_install.sh`

### Docker Commands

- `$ docker images` (list images on docker)

- `$ docker ps` (check the status of executed containers)

- `$ docker logs mongodb` (show event logs)

- `$ docker exec -it mongodb bash` (enter to the container shell)

- `$ docker stop mongodb` (stop run container)

- `$ docker start mongodb` (start container)

- `$ exit` (leave from docker)

### MongoDB Commands

- `$ mongo -host localhost -port 27017` (Enter to the mongodb session)

- `$ exit` (leave from mongodb)