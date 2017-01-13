FROM bitnami/express:4.14.0-r15

MAINTAINER Bitnami <containers@bitnami.com>

USER root

ENV BITNAMI_APP_NAME=che-express
ENV BITNAMI_IMAGE_VERSION=4.14.0-r15

# Install MongoDB module
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8
RUN bitnami-pkg unpack mongodb-3.4.1-1 --checksum 1169f363922417c5d445b1edb7ffda8561e6f6a725b072edca7781dd1859fba0
ENV PATH=/opt/bitnami/mongodb/sbin:/opt/bitnami/mongodb/bin:$PATH

RUN nami initialize mongodb

# Set up Codenvy integration
LABEL che:server:3000:ref=nodejs che:server:3000:protocol=http

RUN rm /app-entrypoint.sh

USER bitnami
WORKDIR /projects

ENV DATABASE_URL=mongodb://localhost:27017/my_project_development \
    TERM=xterm

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "sudo", "env", "HOME=/root", "nami", "start", "--foreground", "mongodb"]
