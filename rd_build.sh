#!/bin/sh

./build-package.sh -a arm openssh
./build-package.sh -a arm vim
./build-package.sh -a arm libmosquitto
./build-package.sh -a arm libsqlite
tar -czvf rd.tar.gz /system