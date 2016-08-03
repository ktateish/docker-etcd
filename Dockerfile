FROM golang
MAINTAINER Katsuyuki Tateishi <kt@wheel.jp>

ADD build.sh /root/build.sh

CMD ["/root/build.sh"]
