FROM ubuntu:bionic

RUN apt-get update 
RUN apt-get install -y curl \
                       vim \
                       less \
                       libcurl4 \
                       libcurl-dev \
                       libcurl4-gnutls-dev \
                       libssh-dev \
                       libmysqld-dev \
                       libpq-dev \
                       build-essential \
                       net-tools
# Get the Package
# RUN curl -L -o /opt/netxms.deb http://packages.netxms.org/netxms-release_1.1_all.deb && dpkg -i /opt/netxms.deb
# Source code
RUN curl -L -o /opt/netxms.tar.gz https://www.netxms.org/download/releases/3.0/netxms-3.0.2357.tar.gz
RUN tar xzf /opt/netxms.tar.gz -C /opt
RUN cd /opt/netxms-* && ./configure --with-server \
                                    --with-agent \
                                    --with-mysql \
                                    --with-sqlite \
                                    --with-pgsql \
                                    --with-ldap
RUN make
RUN make install
RUN cp -f contrib/netxmsd.conf-dist /etc/netxmsd.conf
RUN cp -f contrib/nxagentd.conf-dist /etc/nxagentd.conf

COPY files/start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh
