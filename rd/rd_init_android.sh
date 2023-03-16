#!/system/bin/sh
tar -xzf /data/rd/rd.tar.gz -C /data/rd
mount -o rw,remount /system
#yes | cp system/* /system/ -rfi
cp system/* /system/ -r

cp /data/rd/rd.rc /etc/init
chmod 644 /etc/init/rd.rc

cp /data/rd/rd.sh /system/rd/bin
chmod +x /system/rd/bin/rd.sh

cp /data/rd/mosquitto.sh /system/rd/bin
chmod +x /system/rd/bin/mosquitto.sh

mkdir /etc/mosquitto/
cp /data/rd/mosquitto.conf /etc/mosquitto/

#ln -s /system/bin/vim /system/bin/vi