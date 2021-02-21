FROM ubuntu:20.04
LABEL maintainer="Sigmonsays <noreply@example.com>"
COPY entrypoint.sh /entrypoint.sh
RUN apt-get update
RUN apt-get install build-essential debhelper devscripts -y
ENTRYPOINT ["/entrypoint.sh"]
