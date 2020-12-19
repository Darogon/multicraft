FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody
RUN usermod -d /home nobody
RUN usermod -a -G users www-data
RUN chown -R nobody:users /home
RUN echo "Etc/UTC" | tee /etc/timezone
RUN apt-get update -q && apt-get install -qy \
    apache2 \
    php \
    wget \
    php-mysql \
    php-sqlite3 \
    php-gd \
    sudo \
    zip \
    unzip \
    openjdk-8-jre-headless \
    && rm -rf /var/lib/apt/lists/*
RUN wget http://www.multicraft.org/download/linux64 -O /tmp/multicraft.tar.gz && \
    tar xvzf /tmp/multicraft.tar.gz -C /tmp && \
    rm /tmp/multicraft.tar.gz
COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN mkdir -p /multicraft/scripts/
COPY install.sh /multicraft/scripts/install.sh 
RUN chmod +x /multicraft/scripts/install.sh && \
    /multicraft/scripts/install.sh
COPY entrypoint.sh /multicraft/scripts/entrypoint.sh
RUN chmod +x /multicraft/scripts/entrypoint.sh
EXPOSE 80
EXPOSE 21
EXPOSE 6000-6005
EXPOSE 25565
EXPOSE 25565/udp
EXPOSE 19132-19133/udp
VOLUME [/multicraft]
ENV daemonpwd=none
ENV daemonid=1
ENV dbengine=sqlite
ENV mysqlhost=192.168.2.2
ENV mysqldbname=multicraft
ENV mysqldbuser=multicraft
ENV mysqldbpass=multicraft
ENV FTPNatIP=192.168.2.2
CMD ["/multicraft/scripts/entrypoint.sh"]
