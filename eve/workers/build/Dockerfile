FROM scality/clueso-livy:pensieve

#
# Install apt packages needed by the buildchain
#

COPY buildbot_worker_packages.list /tmp/
RUN apt-get update -q \
    && cat /tmp/*_packages.list | xargs apt-get install -qy \
    && pip install pip==9.0.1 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /tmp/*_packages.list

RUN apt-get update -q \
    && apt-get install -y node \
    && apt-get install -y npm \
    && npm install -g n \
    && n 6.9.5


# Install nodejs packages
WORKDIR /usr/lib/
COPY package.json .
RUN npm install && npm install -g mocha

#
# Add user eve
#

RUN adduser -u 1042 --home /home/eve --disabled-password --gecos "" eve \
    && adduser eve sudo \
    && sed -ri 's/(%sudo.*)ALL$/\1NOPASSWD:ALL/' /etc/sudoers

#
# Run buildbot-worker on startup
#

ARG BUILDBOT_VERSION
RUN pip install buildbot-worker==$BUILDBOT_VERSION

ENV CXX=g++-4.9
USER eve
WORKDIR /home/eve/workspace

CMD buildbot-worker create-worker . "$BUILDMASTER:$BUILDMASTER_PORT" "$WORKERNAME" "$WORKERPASS" \
    && buildbot-worker start --nodaemon
