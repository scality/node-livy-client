FROM scality/clueso-livy:pensieve-jay

#
# Install apt packages needed by the buildchain
#

COPY buildbot_worker_packages.list /tmp/
RUN apt-get update -qq \
    && apt-get install -qqy curl \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && cat /tmp/*_packages.list | xargs apt-get install -qy \
    && pip install pip==9.0.1 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /tmp/*_packages.list

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

ENTRYPOINT /bin/bash
