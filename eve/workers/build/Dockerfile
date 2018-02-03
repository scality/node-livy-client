FROM gettyimages/spark:2.1.1-hadoop-2.7

#
# Install apt packages needed by livy
#

RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    wget \
    python \
    python3 \
    git \
    maven curl  \
    iproute2 \
    libsvn1 \
    libcurl3 \
    zip unzip \
    netcat less inetutils-ping \
    python-dev \
    python3-dev \
    libsasl2-modules && \
    rm -rf /var/lib/apt/lists/* && \
    cd && wget https://bootstrap.pypa.io/ez_setup.py && python ez_setup.py && cd -

# Overall ENV vars
ENV HADOOP_CONF_DIR /etc/hadoop/conf

# Set Livy branch
ENV LIVY_BRANCH tags/v0.4.0-incubating

# Set install path for Livy
ENV LIVY_APP_PATH /apps/livy

# Set build path for Livy
ENV LIVY_BUILD_PATH /apps/build/livy

# Clone Livy repository
RUN mkdir -p /apps/build && \
    cd /apps/build && \
    git clone https://github.com/apache/incubator-livy.git $LIVY_BUILD_PATH && \
    cd $LIVY_BUILD_PATH && \
    git checkout $LIVY_BRANCH && \
    mvn -DskipTests -Dspark.version=2.1.1  clean package && \
    unzip $LIVY_BUILD_PATH/assembly/target/*.zip -d /apps && \
    mv /apps/livy* $LIVY_APP_PATH && \
    mkdir -p $LIVY_APP_PATH/logs

COPY conf /apps/livy/conf
COPY conf/log4j.properties /spark/conf/log4j.properties
COPY conf/spark-defaults.conf /spark/conf/spark-defaults.conf

# Set Spark env
ENV SPARK_HOME=/usr/spark-2.1.1
ENV SPARK_CONF_DIR=$SPARK_HOME/conf

COPY entrypoint.sh /app/livy/entrypoint.sh
RUN chmod +x /app/livy/entrypoint.sh

EXPOSE 8998 38600-38632 4040-4056 5005 7077

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

#
# Run buildbot-worker on startup
#

ARG BUILDBOT_VERSION
RUN pip install buildbot-worker==$BUILDBOT_VERSION

#
# Add user eve
#

RUN adduser -u 1042 --home /home/eve --disabled-password --gecos "" eve \
    && adduser eve sudo \
    && sed -ri 's/(%sudo.*)ALL$/\1NOPASSWD:ALL/' /etc/sudoers


ADD supervisor/livy.conf /etc/supervisor/conf.d/

USER eve

#
# Install node modules
#
RUN mkdir /home/eve/node_reqs
COPY package.json /home/eve/node_reqs/package.json
RUN cd /home/eve/node_reqs && npm install

ENV CXX=g++-4.9
USER eve
WORKDIR /home/eve/workspace

CMD buildbot-worker create-worker . "$BUILDMASTER:$BUILDMASTER_PORT" "$WORKERNAME" "$WORKERPASS" \
    && buildbot-worker start --nodaemon
