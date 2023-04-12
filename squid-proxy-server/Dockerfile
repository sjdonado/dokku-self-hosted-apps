FROM debian:bullseye-slim

WORKDIR /usr/local/proxy

EXPOSE 3129

ARG HOSTNAME=''
ARG TOKEN=''

ENV HOSTNAME ${HOSTNAME}
ENV TOKEN ${TOKEN}

ENV GOROOT /usr/local/go
ENV GOPATH /usr/local/proxy
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

RUN apt-get -q update && \
    apt-get -qy install git curl zenity && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
RUN tar -xvf go1.12.7.linux-amd64.tar.gz
RUN mv go /usr/local

RUN git clone https://github.com/hoppscotch/proxyscotch.git /usr/local/proxy/proxyscotch

RUN cd proxyscotch && ./build.sh linux

CMD ["./out/linux-server/server", "--host", "$HOSTNAME:3129", "--token", "$TOKEN"]
