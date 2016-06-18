FROM golang:1.6
MAINTAINER @raben2
ENV INFLUX=0.13
EXPOSE 8083 8086 8086/udp 8088 2003 4242 25827
Volume ['/influx']
RUN apk add python --no-cache --virtual .build-deps
RUN go get github.com/influxdata/influxdb 
RUN cd src/github.com/influxdata/influxdb \
    && git checkout -q $INFLUX \
    && python build.py \
    && go clean -i -r \
    && mv build/influx* /go/bin
COPY influxdb.toml /etc/influxdb.toml
COPY types.db /etc/types.db
RUN apk del --purge .build-deps \
    && rm -rf /go/src/* /usr/local/go/src/* /tmp/* /var/cache/apk/
ENTRYPOINT ["influxd", "--config", "/etc/influxdb.toml"]