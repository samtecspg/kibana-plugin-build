ARG NODE_IMAGE_VERSION=6.11.5
FROM node:${NODE_IMAGE_VERSION}
ARG NODE_IMAGE_VERSION
ENV NODE_IMAGE_VERSION $NODE_IMAGE_VERSION
# to understand syntax above see: 
#   https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#     and
#   https://stackoverflow.com/a/46576667/3334178

ARG ES_TAG=v5.6.5
# the following in part can from SO: https://stackoverflow.com/a/11030332/3334178
RUN git clone --branch $ES_TAG --depth 1  -q https://github.com/elastic/kibana.git
RUN if [ "$NODE_IMAGE_VERSION" = `cat kibana/.node-version` ] ; then echo "Node image matches kibana requested version - happy" ; else echo "node MISMATCHED to kibana - ABORTING! [node_image: $NODE_IMAGE_VERSION - kibana requests: " `cat kibana/.node-version` "]" ; false ; fi
RUN cd kibana \
    && npm install

EXPOSE 5601
WORKDIR /kibana
CMD ["sleep", "1500"]

