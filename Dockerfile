FROM debian
ENV PACKAGES curl git bash wget curl grep tar jq openssh-server supervisor ca-certificates 
RUN apt update && apt install -y $PACKAGES
WORKDIR /microtick
RUN cd /microtick && export DOWNLOAD=`curl -s https://microtick.com/releases/testnet/stargate/ | grep -oP '<a href=".+?">\K.+?(?=<)'|grep mtm|sort -r|head -n2|tail -1` &&\
    export SIGN=`curl -s https://microtick.com/releases/testnet/stargate/ | grep -oP '<a href=".+?">\K.+?(?=<)'|grep mtm|sort -r|head -1` &&\
    wget https://microtick.com/releases/testnet/stargate/$DOWNLOAD && wget https://microtick.com/releases/testnet/stargate/$SIGN &&\
    tar xfv  $DOWNLOAD && cp mtm /usr/bin/
#    cp `echo $DOWNLOAD| sed -r 's/-l.+//'` /usr/bin/mtm
RUN rm -rf /microtick && apt-get clean
ARG password
RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:$password" | chpasswd \
  && rm -rf /var/cache/apk/*
RUN mkdir /run/sshd
RUN sed -ie 's/#Port 22/Port 2242/g' /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 2242 22656 26657
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
