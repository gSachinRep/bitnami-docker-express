FROM bitnami/express:4.14.0-r9

MAINTAINER Bitnami <containers@bitnami.com>

USER root

# Install MongoDB module
RUN bitnami-pkg unpack mongodb-3.2.9-0 --checksum 367db26aa2b687e8a389073809602412bde95d5800f655f4221ab39dc251cd1f
ENV PATH=/opt/bitnami/mongodb/sbin:/opt/bitnami/mongodb/bin:$PATH

RUN nami initialize mongodb

# Set up Codenvy integration
LABEL che:server:3000:ref=nodejs che:server:3000:protocol=http

RUN rm /app-entrypoint.sh

USER bitnami
WORKDIR /projects

ENV DATABASE_URL=mongodb://localhost:27017/my_project_development \
    TERM=xterm

CMD ["/entrypoint.sh", "sudo", "env", "HOME=/root", "nami", "start", "--foreground", "mongodb"]
