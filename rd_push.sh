#!/bin/sh

adb shell su -c mkdir /data/rd
adb push rd.tar.gz /data/rd
adb push rd/rd.rc /data/rd
adb push rd/lvgl.sh /data/rd
adb push rd/smh.sh /data/rd
adb push rd/mosquitto.sh /data/rd
adb push rd/mosquitto.conf /data/rd
adb push rd/sshremote.sh /data/rd
adb push rd/rd_init_android.sh /data/rd
#adb shell su -c /data/rd/rd_init_android.sh