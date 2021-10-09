FROM ubuntu:latest
LABEL author maikebing <mysticboy@live.com>
# docker run -ti   --net=host --rm -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix  x11ubuntu   --gpus
ENV DEBIAN_FRONTEND noninteractive
# RUN apt-get -y   -q   update && apt-get  install  -y   -q  apt-transport-https ca-certificates  
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse apt-get update" > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    apt-get -y  - -q update &&  apt-get install  -y   -q   ca-certificates x11-xserver-utils  dbus-x11  libcanberra-gtk3-module    libpci3 libegl1 libgl1 && \
    apt-get install -yq  fonts-arphic-ukai  fonts-arphic-uming  fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp  fonts-arphic-gkai00mp  fonts-wqy-zenhei  latex-cjk-chinese-arphic-bkai00mp  latex-cjk-chinese-arphic-bsmi00lp  latex-cjk-chinese-arphic-gbsn00lp  latex-cjk-chinese-arphic-gkai00mp  xfonts-intl-chinese  xfonts-intl-chinese-big fonts-cns11643-kai  fonts-cns11643-sung  fonts-moe-standard-kai  fonts-moe-standard-song && \
    apt-get clean && apt-get autoremove   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
# RUN  export DISPLAY=host.docker.internal:0 && xhost + 
RUN  apt-get update  -yq  && apt install git g++ binutils autoconf automake libtool make cmake pkg-config  -yq && \
    apt install libgtk2.0-dev  -yq && \
    apt install libjpeg-dev libpng-dev libfreetype6-dev libharfbuzz-dev  -yq && \
    apt install libinput-dev libdrm-dev libsqlite3-dev libxml2-dev  sudo  libssl-dev -yq &&  \
    apt-get clean && apt-get autoremove   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
RUN   git clone https://gitlab.fmsoft.cn/VincentWei/build-minigui-5.0 && cd build-minigui-5.0/ && cp config.sh myconfig.sh && \
     ./fetch-all.sh  &&   ./build-deps.sh && ./build-minigui.sh
ENTRYPOINT [ "/build-minigui-5.0/cell-phone-ux-demo/mginit" ]    