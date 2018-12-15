
FROM gitlab/gitlab-ce:${GITLAB_VERSION}

ARG GITLAB_VERSION
ARG GITLAB_DIR
ARG GITLAB_VOLUME

ENV GITLAB_VERSION=${GITLAB_VERSION}
ENV GITLAB_DIR=${GITLAB_DIR}
ENV GITLAB_VOLUME=${GITLAB_VOLUME}


MAINTAINER  Philippe<philippe@savary.space> ${GITLAB_VERSION}


COPY init /usr/local/bin/gitlab-init
RUN chmod -R 700 /usr/local/bin/gitlab-init

# Expose web & ssh
#EXPOSE 443 80 22

# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/usr/local/bin/gitlab-init"]
