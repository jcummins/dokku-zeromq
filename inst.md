!/usr/bin/env bash
#set -eo pipefail; [[ $DOKKU_TRACE ]] && set -xi
set -e
# This plugin runs commands just before the build is run
# The only things here should be any global dependencies
# that your build process depends on.
# Beward that this may significantly slow down you build
# because we have to wait for these to install.

# Set the plugin name
PLUGINNAME = "ZeroMQ"
PLUGINCOMMAND = "apt-get update -y && apt-get install -y libtool binutils autoconf automake make g++ uuid-dev wget && wget http://download.zeromq.org/zeromq-3.2.4.tar.gz && tar -zxvf zeromq-3.2.4.tar.gz && cd zeromq-3.2.4 && ./configure --prefix=/usr/lib && make && make install && export CXXFLAGS='-I /usr/lib' && export LDFLAGS='-L /usr/lib -Wl,-rpath=/usr/lib'";
# Set the buildpack image
IMAGE="progrium/buildstep"

echo "Running $PLUGINNAME Prebuild"
# Create a fork of the buildpack image and run a command against it
id=$(docker run -i -a stdin $IMAGE /bin/bash -c "$PLUGINCOMMAND");

echo "Attaching $PLUGINNAME"
# Attach the newly formed image to the running container
docker attach $id

echo "Waiting for $PLUGINNAME to complete. Please wait."
# Wait until the new image is done doing things before commiting it to the buildpack image
test $(docker wait $id) -eq 0;i

echo "Commiting $PLUGINNAME"
# Commit the new image to the buildpack
docker commit $id $IMAGE > /dev/null
