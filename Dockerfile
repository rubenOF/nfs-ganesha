FROM ubuntu:bionic
MAINTAINER Mitchell Hewes <me@mitcdh.com>

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y gnupg2 --no-install-recommends \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 34DC57CA \
 && echo "deb http://ppa.launchpad.net/nfs-ganesha/nfs-ganesha-2.8/ubuntu bionic main" > /etc/apt/sources.list.d/nfs-ganesha-2.8.list \
 && echo "deb http://ppa.launchpad.net/nfs-ganesha/libntirpc-1.8/ubuntu bionic main" > /etc/apt/sources.list.d/libntirpc-1.8.list \
 && apt-get update \
 && apt-get install -y netbase nfs-common dbus nfs-ganesha nfs-ganesha-vfs --no-install-recommends \
 && apt-get remove -y gnupg \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && mkdir -p /run/rpcbind /export /var/run/dbus \
 && touch /run/rpcbind/rpcbind.xdr /run/rpcbind/portmap.xdr \
 && chmod 755 /run/rpcbind/* \
 && chown messagebus:messagebus /var/run/dbus

# Add startup script
COPY start.sh /

# NFS ports and portmapper
EXPOSE 2049 38465-38467 662 111/udp 111

# Start Ganesha NFS daemon by default
CMD ["/start.sh"]

