FROM gliderlabs/alpine:latest
MAINTAINER @raben2

ENV GOLANG_VERSION 1.6
ENV GOLANG_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        curl \
        gcc \
        musl-dev \
        go
RUN set -ex \
    && apk add --no-cache bash git ca-certificates openssl
RUN curl -L "$GOLANG_URL" -o /tmp/golang.tar.gz \
    && tar -C /usr/local -xzf /tmp/golang.tar.gz 
ENV GOPATH=/go
ENV GOROOT=/usr
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
ENV GOROOT_BOOTSTRAP=/usr
RUN ln -sf /usr/lib/go/pkg /usr/pkg \
    && ln -sf /usr/lib/go/pkg/tool/linux_amd64 /usr/pkg/tool/linux_amd64
RUN ln -sf /usr/lib/go/src /usr/src
RUN cd /usr/local/go/src \
    && ./make.bash \

RUN go get github.com/sparrc/gdm \
	&& rm -rf /tmp/* /var/cache/apk/*
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH