# Automation Docker and MongoDB
<p align="center">
  <img src="https://miro.medium.com/max/3000/1*HWfG5YkyX5atHZjDFrHfaw.png" width="450px" height="150px" />
</p>

## Description

This project automates the MongoDB installation using a Docker container on Linux. Only exists support for Ubuntu and Manjaro. The repository contains the next two files:

1. ***full_install.sh*** (Install Docker and MongoDB Container)

2. ***mongodb_install.sh*** (Install MongoDB Container)



## Installation

To run a script, you must execute it using **sudo** command.

`$ sudo ./full_install.sh`

`$ sudo ./mongodb_container_install.sh`



### Issues

If the script goes down because of a permission error, you must grant permissions to the files.

`# chmod +x full_install.sh`

`# chown your_user:your_user full_install.sh`

___

### Docker Commands

- `$ docker images` (List images on docker)

- `$ docker ps` (Check the status of executed containers)

- `$ docker logs mongodb` (Show event logs)

- `$ docker exec -it mongodb bash` (Enter to the container shell)

- `$ docker stop mongodb` (Stop run container)

- `$ docker start mongodb` (Start container)

- `$ exit` (Leave from docker)

### MongoDB Commands

- `$ mongo -host localhost -port 27017` (Login to the mongodb session)

- `$ exit` (Leave from mongodb)

___

## Author
- [Antony Hernandez](https://github.com/anhb)
