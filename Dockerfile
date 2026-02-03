FROM ubuntu:22.04
LABEL author maikebing <mysticboy@live.com>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        fonts-arphic-ukai fonts-arphic-uming fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-wqy-zenhei \
        git g++ binutils autoconf automake libtool make cmake pkg-config electric-fence \
        libjpeg-dev libpng-dev libfreetype6-dev libharfbuzz-dev \
        libinput-dev libdrm-dev libsqlite3-dev libxml2-dev libssl-dev libconfig-dev libpq-dev \
        sudo openssh-server gdb gdbserver busybox wget && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

RUN   git clone https://github.com/VincentWei/build-minigui-5.0  && \
      cd build-minigui-5.0/ && cp config.sh myconfig.sh && ./fetch-all.sh   && \
    #   sed -i -e 's/mg-tests mg-samples mg-demos cell-phone-ux-demo/mg-samples mg-demos cell-phone-ux-demo/g' build-minigui.sh && \
      ./build-deps.sh && ./build-minigui.sh ths &&  \
      cd .. && rm  ./build-minigui-5.0 -rf

 
RUN cd ~/ && \
	wget https://curl.haxx.se/download/curl-7.67.0.tar.gz && \
	tar xzf curl-7.67.0.tar.gz &&  cd ~/curl-7.67.0/ && \
	./buildconf && ./configure  && make  && make install && \
    rm  ~/curl-7.67.0/ -rf


RUN mkdir /var/run/sshd 
RUN echo 'root:1-q2-w3-e4-r5-t' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

