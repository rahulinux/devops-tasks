# Create base image

FROM base:latest

MAINTAINER Rahul Patil<rahul.ks.patil@gmail.com>

# Note: following command written like ungly to optimize docker image size.
ADD ./.ssh/ansible_id_rsa.pub /root/.ssh/authorized_keys

# Installation:
# Import MongoDB public GPG key AND create a MongoDB list file
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-3.0.list && DEBIAN_FRONTEND="noninteractive" apt-get update && \
    apt-get install -y openssh-server openssh-client python python-dev build-essential tcl8.5 mongodb-org=3.0.1\
      mongodb-org-server=3.0.1 mongodb-org-shell=3.0.1 mongodb-org-mongos=3.0.1 nginx python-pip libmysqlclient-dev\
      mongodb-org-tools=3.0.1 mysql-server mysql-client python-mysqldb redis-server && mkdir -p /data/db &\
      (grep -q LC_ALL /etc/profile.d/env.sh || echo 'export LC_ALL=C' >>/etc/profile.d/env.sh) && mkdir /var/run/sshd | true &&\
      pip install uwsgi && chmod 0700  /root/.ssh/ && chmod 0600  /root/.ssh/authorized_keys && \
      echo "\ndaemon off;" >> /etc/nginx/nginx.conf && chown -R www-data:www-data /var/lib/nginx 


ADD ./requirements.txt /tmp/requirements.txt

RUN mkdir /srv/python_envs/ && cd /srv/python_envs/ && virtualenv imdb_api && \
      . /srv/python_envs/imdb_api/bin/activate && pip install -r /tmp/requirements.txt && deactivate

RUN echo Clean up process.. && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
