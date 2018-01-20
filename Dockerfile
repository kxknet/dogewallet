FROM debian:jessie
MAINTAINER ddosov.net <support@ddosov.net>
RUN export DEBIAN_FRONTEND=noninteractive
if [ ! -f ~/dogecoin-bin/bin/dogecoind ]; then
RUN wget --progress=bar:force https://github.com/dogecoin/dogecoin/releases/download/v1.10.0/dogecoin-1.10.0-linux64.tar.gz -O dogecoin.tar.gz
RUN tar -zxvvf dogecoin.tar.gz
RUN rm dogecoin.tar.gz
RUN mv dogecoin-1.10.0 dogecoin-bin
RUN mkdir ~/.dogecoin
RUN echo rpcuser=dogecoinrpc > ~/.dogecoin/dogecoin.conf
RUN PWord=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1`
RUN echo rpcpassword=$PWord >> ~/.dogecoin/dogecoin.conf
RUN echo Downloading Bootstrap.dat from jrwr.io
RUN wget --progress=bar:force http://185.21.217.21:9987/bootstrap.dat -O ~/.dogecoin/bootstrap.dat
RUN ~/dogecoin-bin/bin/dogecoind -maxconnections=500 -daemon
RUN echo Run \" tail -f ~/.dogecoin/debug.log \" to watch the download status.
