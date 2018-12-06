ARG NODE_IMAGE_VERSION=8.11.3
FROM node:${NODE_IMAGE_VERSION}
ARG NODE_IMAGE_VERSION
ENV NODE_IMAGE_VERSION $NODE_IMAGE_VERSION
# to understand syntax above see: 
#   https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#     and
#   https://stackoverflow.com/a/46576667/3334178

ENV YARN_VERSION 1.12.3

RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz

ARG ES_TAG=v6.3.2
RUN apt-get update && apt-get install -y vim zip
# the following in part can from SO: https://stackoverflow.com/a/11030332/3334178
RUN git clone --branch $ES_TAG --depth 1  -q https://github.com/elastic/kibana.git
RUN if [ "$NODE_IMAGE_VERSION" = `cat kibana/.node-version` ] ; then echo "Node image matches kibana requested version - happy" ; else echo "node MISMATCHED to kibana - ABORTING! [node_image: $NODE_IMAGE_VERSION - kibana requests: " `cat kibana/.node-version` "]" ; false ; fi
# handy reconfiguration sed's from @rigon https://github.com/rigon/docker-kibana-dev/blob/master/Dockerfile
RUN sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 'http://elasticsearch:9200'!" /kibana/config/kibana.yml
RUN sed -ri "s!^(\#\s*)?(server\.host:).*!\2 '0.0.0.0'!" /kibana/config/kibana.yml

EXPOSE 5601 5603
WORKDIR /
CMD ["sleep", "1500"]

