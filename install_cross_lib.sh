#!/bin/sh

#�������zmq�Ŀ�



#�������protobuf�Ŀ�

./configure --host=arm-linux-gnueabihf --prefix=/usr/local/arm --with-protoc=/usr/local/bin/protoc
make
make check
sudo make install