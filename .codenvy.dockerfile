FROM bitnami/express:4.14.0-r19

MAINTAINER Bitnami <containers@bitnami.com>

USER root

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list
RUN apt-get update && apt-get install -t jessie-backports -y openjdk-8-jdk-headless
RUN install_packages git subversion openssh-server rsync
RUN mkdir /var/run/sshd && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV BITNAMI_APP_NAME=che-express
ENV BITNAMI_IMAGE_VERSION=4.14.0-r18

# Install MongoDB module
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8
RUN bitnami-pkg unpack mongodb-3.4.1-1 --checksum 1169f363922417c5d445b1edb7ffda8561e6f6a725b072edca7781dd1859fba0
ENV PATH=/opt/bitnami/mongodb/sbin:/opt/bitnami/mongodb/bin:$PATH

RUN nami initialize mongodb

# Install neo4j
RUN wget -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
RUN echo 'deb https://debian.neo4j.org/repo stable/' | tee /etc/apt/sources.list.d/neo4j.list
RUN apt-get update
RUN apt-get install neo4j

# Set up Codenvy integration
LABEL che:server:3000:ref=nodejs che:server:3000:protocol=http

RUN rm /app-entrypoint.sh

USER bitnami
WORKDIR /projects

ENV DATABASE_URL=mongodb://localhost:27017/my_project_development \
    TERM=xterm

ENTRYPOINT ["/entrypoint.sh"]
CMD sudo /usr/sbin/sshd && sudo env HOME=/root nami start --foreground mongodb

