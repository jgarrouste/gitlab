# GitLab

## Overview

This code installs and maintains a gitlab repo using gitlab community docker images.


## Requirements

This requires Docker engine and docker-compose to be installed.

See docker documentation to [install Docker](https://docs.docker.com/install/) engine.

See docker-compose documentation to [install Docker-compose](https://docs.docker.com/compose/install/) tool.

[Gitlab community versions](https://hub.docker.com/r/gitlab/gitlab-ce) are available on Dockerhub.


## Install GitLab


```shell
$ cd /path/to/download/gitlab/installer
$ git clone https://github.com/philsavary/gitlab.git
$ cd gitlab
$ sh install.sh
...
$ docker-compose stop         // if GitLab is already running
$ docker-compose up -d        // to start GitLab

```
Installer will prompt:

* Absolute path to the directory where gitlab data will is stored
* Gitlab domain name (git.example.com)
* Gitlab Docker Registry domain name (registry.example.com)
* Absolute path to the SSL directory on the host. This is needed to use gitlab / letsencrypt auto generated certificates outside the gitlab container e.g. with a reverse proyy
* Gitlab version number ([see tags](https://hub.docker.com/r/gitlab/gitlab-ce))
* SMTP server domain name (e.g. mail.example.com)
* Username used to authenticate to SMTP Server (admin@example.com)
* Password used to authenticate to SMTP Server
* User email that Gitlab will send email from (admin@example.com)
* User email domain name (example.com)


## Upgrade & rollback gitlab version

To upgrade or rollback to a new or previous gitlab version, just run install.sh script with the desired [gitlab version tag](https://hub.docker.com/r/gitlab/gitlab-ce/tags).
