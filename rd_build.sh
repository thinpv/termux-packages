#!/bin/sh

./build-package.sh -a arm openssh
./build-package.sh -a arm vim
./build-package.sh -a arm libmosquitto
./build-package.sh -a arm libsqlite
./build-package.sh -a arm smh
tar -czf rd.tar.gz /system/rd