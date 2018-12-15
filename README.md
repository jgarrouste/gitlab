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
```


## Upgrade & rollback gitlab version

To upgrade or rollback to a new or previous gitlab version, just run install.sh script with the desired [gitlab version tag](https://hub.docker.com/r/gitlab/gitlab-ce/tags).
