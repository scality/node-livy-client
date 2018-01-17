#!/bin/bash
set -e -o pipefail

if [ -z ${HOST+x} ]; then
# if host isn't known then check outbound IP when contacting google
  export LIBPROCESS_IP=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)
else
  export LIBPROCESS_IP=$HOST
fi

# Wait for spark master
# This allows clean startup
RETRY=15
echo "Waiting for spark master"
while ! nc -z spark-master 7077 &>/dev/null ; do
  RETRY=$((RETRY-1))
  if [ $RETRY == 0 ]; then
    echo "Cannot contact spark master on 7077"
    exit 1
  fi
  sleep 1
done

echo "Starting Livy Server"
# start Livy
$LIVY_APP_PATH/bin/livy-server $@
