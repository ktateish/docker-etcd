FROM golang:1.6
MAINTAINER Katsuyuki Tateishi <kt@wheel.jp>

VOLUME ["/go"]
ADD build.sh /build.sh

CMD ["/build.sh"]
