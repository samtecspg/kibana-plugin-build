#!/bin/sh
if [ -z "$1" ]
  then
    echo "Kibana release number required as an argument [For instance '$0 5.6.5']"
    exit 1
fi

export ELASTIC_VERSION=$1

echo "Attempting build of Kibana:"
echo " - Kibana version $ELASTIC_VERSION"
export KIBANA_NODE_VERSION=`curl -s https://raw.githubusercontent.com/elastic/kibana/v$ELASTIC_VERSION/.node-version`
echo " - Node version $KIBANA_NODE_VERSION"
docker-compose build kibana
