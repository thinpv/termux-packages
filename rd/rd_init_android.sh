#!/system/bin/sh
tar -xzvf /data/rd/rd.tar.gz -C /data/rd
mount -o rw,remount /system
rm -rf /system/rd
mv system/rd/ /system/
cp /data/rd/rd.rc /etc/init
cp /data/rd/rd.sh /system/rd/bin
cp /data/rd/mosquitto.sh /system/rd/bin
cp /data/rd/mosquitto.conf /system/rd/etc/mosquitto/
chmod 644 /etc/init/rd.rc
chmod +x /system/rd/bin/rd.sh
chmod +x /system/rd/bin/mosquitto.sh