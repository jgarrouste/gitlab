# GitLab

RenaultDigital gitlab repository and docker containers registry.
This setup is made for production and is meant to enable a restart of GitLab within 15 mn on a different instance if the prime instance or its supporting machine were to crash (fast disaster recovery).
It involves:
- 2 instances of GitLab ("master" and "slave") in separate AWS EC2 instances with EBS volumes
- the persistence of GitLab data in volumes shared with the instances hosts, themselves in AWS EBS volumes
- constantly keeping the slave gitlab data updated with the gitlab data of the master, with the use of the rsync utility 

As an additional safety measure, the present project is meant to be hosted on a separate git Server: see the git\_server\_for\_gitlab\_code project.


## Create AWS ami with Docker, Docker Compose, and GitLab

Edit the `variables.json` file in the `packer` directory.
See the `variables_template.json` file for the list of variables to complete.

Build the AMI:
```shell
$ cd packer
$ packer build -var-file=variables.json -debug -on-error=cleanup gitlab_packer.json
```

## Launch instances with ansible

Ensure prerequisites are fulfilled (see [Ansible Prerequisites](Ansible prerequisites: install and configure AWS CLI, boto and Ansible) below).

Set-up or update the variables (particularly AWS image.id) in the `aws_vars.yml` file  

Then run
```shell
$ cd ansible
$ ansible-playbook gitlab-production.yml -f 1
...
```

Then associate elastic IP to master GitLab, with the AWS console.  

## Start master GitLab service and set up rsync between master and slave

The rsync setup is not persisted when the gitLab-rsync Docker container (master or slave) is stopped or removed, it must therefore be redone at each start or restart.  

First, inside the slave GitLab container, run:
`$ gitlab-sync add <username>:<password>@<master gitlab-ip>`
Check that the user is there with
`$ gitlab-sync ls`

Second, inside the master GitLab container, run:
`$ gitlab-sync add <username>:<password>@<slave gitlab-ip>`
> Beware: make sure username and password are the same on both sides
Check that the user is there with
`$ gitlab-sync ls`
Then start synchronization
`$ gitlab-sync start`

Third, start the master GitLab container:
`$ docker-compose up -d gitlab`  
  
  
## Disaster recovery procedure

This procedure is meant for the case when the master GitLab has failed.
> TODO: write Ansible or Terraform script to automate disaster recovery

##### Determine whether master and slave has synchronized data and if not when the slave data was last updated   
From : rsync logs, status of files inside containers (by comparing inside gitlab-rsync containers on slave and master)
  
If ok  
##### Stop the rsync client on master side (assuming container is up)
`$ docker exec -it gitlab-rsync gitlab-sync stop`
##### Forbid access to master gitlab by changing security group
Replace the `gitlab-open` security group with `gitlab-slave` security group for the EC2 instance hosting the master GitLab 
##### Start slave container 
`$ docker-compose up -d gitlab`
##### Change security group to open access
Replace the `gitlab-slave` security group with `gitlab-open` security group for the EC2 instance hosting the slave GitLab 
##### Assign ex-master GitLab instance elastic IP to the new master instance (ex slave)

Now you have the old slave running as the new master GitLab.  

##### Set up runners

##### Recreate new slave
##### Set up rsync between new master and new slave
As described above [Set up rsync between master and slave](Set up rsync between master and slave).
##### Make sure you understand why the the master failed in the first place!


## Ansible prerequisites: install and configure AWS CLI, boto and Ansible

#### AWS CLI
[http://docs.aws.amazon.com/cli/latest/userguide/installing.html](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)  
[http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)  

Test:
```shell
$ aws ec2 describe-instances
```

#### EC2.py script and the EC2.ini config file
[https://aws.amazon.com/fr/blogs/apn/getting-started-with-ansible-and-dynamic-amazon-ec2-inventory-management/](https://aws.amazon.com/fr/blogs/apn/getting-started-with-ansible-and-dynamic-amazon-ec2-inventory-management/)  

Test:
```shell
python /etc/ansible/ec2.py --list
```

#### Make sure the boto Python module installed
