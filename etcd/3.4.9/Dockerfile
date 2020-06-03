FROM alpine:latest

RUN apk add --update ca-certificates openssl tar && \
    wget https://github.com/etcd-io/etcd/releases/download/v3.4.9/etcd-v3.4.9-linux-amd64.tar.gz && \
    tar xzvf etcd-v3.4.9-linux-amd64.tar.gz && \
    mv etcd-v3.4.9-linux-amd64/etcd* /usr/local/bin/ && \
    apk del --purge tar openssl && \
    rm -Rf etcd-v3.4.9-linux-amd64* /var/cache/apk/* && \
    echo "Asia/Shanghai" > /etc/timezone
WORKDIR /