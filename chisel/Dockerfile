FROM alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache curl

RUN curl -sSL https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz | zcat > /bin/chisel
RUN chmod +x /bin/chisel

EXPOSE 2334

CMD chisel server --port=2334 --auth $CHISEL_AUTH --reverse --verbose
