#!/system/bin/sh
tar -xzf /data/rd/rd.tar.gz -C /data/rd
mount -o rw,remount /system
#yes | cp system/* /system/ -rfi
cp system/* /system/ -r
cp /data/rd/rd.rc /etc/init
cp /data/rd/rd.sh /system/bin
cp /data/rd/mosquitto.sh /system/bin
cp /data/rd/mosquitto.conf /etc/mosquitto/
chmod 644 /etc/init/rd.rc
chmod +x /system/bin/rd.sh
chmod +x /system/bin/mosquitto.sh
ln -s /system/bin/vim /system/bin/vi