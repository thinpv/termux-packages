#!/bin/sh

git submodule update --init --recursive
./build-package.sh -a arm lvgl
./build-package.sh -a arm openssh
./build-package.sh -a arm vim
./build-package.sh -a arm libmosquitto
./build-package.sh -a arm libsqlite
./build-package.sh -a arm htop
./build-package.sh -a arm smh
./build-package.sh -a arm sshremote
tar -czf rd.tar.gz /system