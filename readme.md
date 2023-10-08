Ansible Engine
=========

The ansible engine is a concept that is used to build a ansible run time environment without the need to install ansible on the host system. This is useful if you want to run ansible on a windows system or if you want to run ansible on a linux system without installing it.

## Overview

This repository contains the dockerfile that is used to build a local ansible container by leveraging the [willhallonline/ansible](https://github.com/willhallonline/docker-ansible) container and adding a directory at the root of the container that is used for your ssh keys that are mounted in at runtime.

## Requirements / configurations

By default the ansible engine will require a container runtime such as docker or podman.
In the scripts that are running the container I try to determine which container runtime is available and use that. right now the scripts are only setup to use docker and podman.

This is configured in the globals.sh file. If you want to use a different container runtime you will need to update the globals.sh file to use the correct commands for your container runtime.

As mentioned in the WSL section below, we will attempt to mount your ssh keys from your host system into the container. This is done by mounting the .ssh directory from your home directory into the container. If you are using WSL you will need to create a symbolic link to your ssh keys in your linux home directory. (see WSL section below) 

Inside the run.sh script you will need to update the following variables to match your environment.

```bash
SSHFolder="~/.ssh/" # This is the location of your ssh keys on your host system.
ANSIBLESSHKeyName=ansible # This is the name of the ssh key that you want to use for ansible
```

If you need to mount additional keys into the container you can add them to the run.sh script. 

```bash
-v "$SSHFolder/$NEWKEY":"/root/.ssh/$NEWKEY" 
```

### Ansible configuration

the ansible configuration is based on mounting the directory `/ansible` from this repo into the container at /etc/ansible. This allows you to keep your ansible configuration, hosts, roles, collections and playbooks in this repo and have them available in the container.

#### Inventory 

Ansible automates tasks on managed nodes or “hosts” in your infrastructure, using a list or group of lists known as inventory. You can pass host names at the command line, but most Ansible users create inventory files. Your inventory defines the managed nodes you automate, with groups so you can run automation tasks on multiple hosts at the same time. Once your inventory is defined, you use patterns to select the hosts or groups you want Ansible to run against.

My inventory file is provided in this repository and will continue to be updated as I add more hosts to my environment, as a good example. 

More information can be found here on [how to manage your inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html). 

#### Configuration file 

Ansible uses a configuration file to determine how it will run. This file is located in the ansible directory of this repository. This configuration file works with this repo and makes sure that your ansible roles/collections are installed back to this repository.

More information can be found here on [how to manage your configuration file](https://docs.ansible.com/ansible/latest/reference_appendices/config.html).

#### Playbooks

Playbooks are stored in the ansible/playbooks directory of this repository. Most of the time I have my playbooks divided up by the type of task that they are performing and if they are role based or not. Similar to this structure below.

```
- ansible
  - role_playbooks
    - grouping
      - playbook.yml
      - playbook2.yml
    - grouping2
      - playbook.yml
      - playbook2.yml
  - grouping
    - playbook.yml
    - playbook2.yml
```

## Usage
To use the ansible engine you will need to run the run.sh script. This script will build the container if it does not exist and then run the container. This run script will mount your ssh keys into the container and then run the ansible container.

Demos can be found in the makefile. However the basic usage is as follows.

### ansible-playbook

To kick off a playbook you will need to pass the playbook name as an argument to the run.sh script. 

```bash
./build/scripts/run.sh ansible-playbook /etc/ansible/playbooks/test.yml
```

### ansible-galaxy

To run ansible-galaxy you will need to pass the galaxy command as an argument to the run.sh script. 

```bash
./build/scripts/run.sh ansible-galaxy install -r /etc/ansible/requirements.yml
```

As a note here, I manage all the roles and collections through my requirements.yml file. This allows me to keep references to the roles and collections with my playbooks while keeping this repository clean.

#### new galaxy role

There is a helper function in the makefile that will create a new galaxy role for you. This will create a new role in the roles directory and then add the role to the requirements.yml file. 

```bash
make new-role ROLE=<role name>
```

### WSL 

If you are using WSL your ssh keys will be mounted in from your windows system. However they will not be at your linux user home directory. You will need to create a symbolic link to your ssh keys in your linux home directory. 

```bash
ln -s /mnt/c/Users/<username>/.ssh ~/.ssh
# If you have spaces, you will need to escape them
ln -s /mnt/c/Users/<My\ username>/My\ Documents/.ssh ~/.ssh
```

if wsl is causing permissions issues with the simlink you can try modifying the wsl config to allow meta permissions to be created on files in your windows directory. OR you can just copy the ssh keys into your linux home directory. 


This allows the ansible container to find your ssh keys. 

## FAQ

### Why not just install ansible on my host system?

You can install ansible on your host system. However, I like to keep my host system as clean as possible. I also like to keep my ansible environment as portable as possible. This allows me to run ansible on any system that has a container runtime installed.

### Why not just use the willhallonline/ansible container?

Honestly, I could just use the willhallonline/ansible container because right now I  am not modifying anything to the base container besides making sure that the directory has the appropriate permissions for ssh keys. However, I like to have the ability to add additional packages/configurations to the container if I need to.

### Why don't you store roles/collections in this repository?

I don't store roles/collections in this repository because I don't want to have to manage the updates to the roles/collections. I would rather have the roles/collections managed by the ansible-galaxy command. This allows me to keep my playbooks clean and only have the roles/collections that I need for the playbook.