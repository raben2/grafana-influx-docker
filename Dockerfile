FROM golang:1.6
MAINTAINER @raben2
EXPOSE 3000
ENV GRAFANA_VERSION=v3.0.x
RUN apk add --no-cache --virtual .build-deps \
    curl \
    git \
    nodejs \
    make \ 
    gcc \
    g++ \
    python \
    linux-headers \
    paxctl \
    libgcc \
    libstdc++ \
    gnupg
RUN apk add --no-cache fontconfig sqlite
RUN bash \
    && go get -d github.com/grafana/grafana/...
ENV GO15VENDOREXPERIMENT=1
WORKDIR /go/src/github.com/grafana/grafana
RUN bash \
	&& git checkout -q $GRAFANA_VERSION \
	&& go run build.go setup \
	&& godep restore \
	&& chmod +x build.go
RUN bash \
    && cd /go/src/github.com/grafana/grafana \
    && go run build.go build 
RUN npm install \
    && npm install -g grunt-cli
RUN grunt --force
RUN go clean -i -r \
    && ln -sf /go/src/github.com/grafana/grafana /grafana 
VOLUME ['/grafana']
RUN mkdir -p /grafana/data \
    && mkdir /grafana/data/plugins \
    && mkdir /grafana/data/dashboards \
    && mkdir /grafana/data/logs 
RUN /go/src/github.com/grafana/grafana/bin/grafana-cli --pluginsDir "/grafana/data/plugins" plugins install grafana-clock-panel \
    && /go/src/github.com/grafana/grafana/bin/grafana-cli --pluginsDir "/grafana/data/plugins" plugins install grafana-piechart-panel \
    && /go/src/github.com/grafana/grafana/bin/grafana-cli --pluginsDir "/grafana/data/plugins" plugins install grafana-simple-json-datasource
RUN rm -rf /tmp/* \
    /var/cache/apk/* \
    && npm uninstall -g grunt-cli \
    && apk del --purge .build-deps 

ADD grafana.ini /grafana/conf/defaults.ini

ENTRYPOINT 'bin/grafana-server'