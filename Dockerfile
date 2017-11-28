FROM alpine:3.5

RUN apk add --no-cache wget

RUN wget --no-check-certificate https://github.com/gohugoio/hugo/releases/download/v0.31.1/hugo_0.31.1_Linux-64bit.tar.gz \
  && tar zvfx *.tar.gz \
  && mv hugo /usr/bin/ \
  && chmod +x /usr/bin/hugo

WORKDIR /tmp

ENTRYPOINT ["hugo"]
