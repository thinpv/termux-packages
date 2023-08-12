#!/system/bin/sh
tar -xzf /data/rd/rd.tar.gz -C /data/rd
mount -o rw,remount /system
#yes | cp system/* /system/ -rfi
rm /system/bin/demo_s8
cp system/* /system/ -r

cp /data/rd/rd.rc /etc/init
chmod 644 /etc/init/rd.rc

#cp /data/rd/lvgl.sh /system/bin
#chmod +x /system/bin/lvgl.sh

cp /data/rd/smh.sh /system/bin
chmod +x /system/bin/smh.sh

cp /data/rd/mosquitto.sh /system/bin
chmod +x /system/bin/mosquitto.sh

mkdir /etc/mosquitto/
cp /data/rd/mosquitto.conf /etc/mosquitto/

cp /data/rd/sshremote.sh /system/bin
chmod +x /system/bin/sshremote.sh

#ln -s /system/bin/vim /system/bin/vi
