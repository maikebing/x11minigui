# x11minigui

测试环境为 Windows 11 +WSL2 , Docker 启动命令如下， 
docker run -ti   --net=host --rm -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix  x11ubuntu   --gpus
