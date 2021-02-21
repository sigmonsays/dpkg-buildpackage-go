FROM ubuntu:20.04
LABEL maintainer="Sigmonsays <noreply@example.com>"
COPY entrypoint.sh /entrypoint.sh
COPY init.sh /init.sh
RUN bash /init.sh
env DEBIAN_FRONTEND=noninteractive
env DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get update
RUN apt-get install build-essential debhelper devscripts equivs -y
ENTRYPOINT ["/entrypoint.sh"]
