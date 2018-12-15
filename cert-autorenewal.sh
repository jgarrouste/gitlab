#!/bin/bash

cd /home/gitlab

#1.stop gitlab (I know it may be a little excessive, but now we are sure nothing is listening on any port)
docker-compose stop

#2. Renew certificate if needed
letsencrypt renew

#3.restart gitlab
docker-compose start


