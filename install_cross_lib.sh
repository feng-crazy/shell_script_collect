#!/bin/sh

#交叉编译zmq的库



#交叉编译protobuf的库

./configure --host=arm-linux-gnueabihf --prefix=/usr/local/arm --with-protoc=/usr/local/bin/protoc
make
make check
sudo make install