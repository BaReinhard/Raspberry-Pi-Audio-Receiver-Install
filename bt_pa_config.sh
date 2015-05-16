#!/bin/bash

read -p "Bluetooth device name: " BT_NAME

#--------------------------------------------------------------------
function tst {
    echo "Executing: $*"
    if ! $*; then
        echo "Exiting scrip due to error from: $*"
        exit 1
    fi	
}
#--------------------------------------------------------------------

tst cd `dirname $0`

tst sudo cp init.d/pulseaudio /etc/init.d
tst sudo chmod +x /etc/init.d/pulseaudio
tst sudo update-rc.d pulseaudio defaults

tst sudo cp init.d/bluetooth /etc/init.d
tst sudo chmod +x /etc/init.d/bluetooth
tst sudo update-rc.d bluetooth defaults

tst sudo cp init.d/bluetooth-agent /etc/init.d
tst sudo chmod +x /etc/init.d/bluetooth-agent
tst sudo update-rc.d bluetooth-agent defaults

tst sudo cp usr_local_bin/bluez-udev /usr/local/bin
tst sudo chmod 755 /usr/local/bin/bluez-udev

tst sudo cp usr_local_bin/simple-agent.autotrust /usr/local/bin
tst sudo chmod 755 /usr/local/bin/simple-agent.autotrust

tst sudo cp usr_local_bin/say.sh /usr/local/bin
tst sudo chmod 755 /usr/local/bin/say.sh

tst sudo cp usr_local_bin/bluezutils.py /usr/local/bin

sudo patch /etc/udev/rules.d/99-input.rules << EOT
***************
*** 1 ****
--- 1,2 ----
  SUBSYSTEM=="input", GROUP="input", MODE="0660"
+ KERNEL=="input[0-9]*", RUN+="/usr/local/bin/bluez-udev"
EOT

sudo patch /etc/bluetooth/main.conf << EOT
***************
*** 7,8 ****
--- 7,9 ----
  #Name = %h-%d
+ Name = ${BT_NAME}

***************
*** 11,12 ****
--- 12,14 ----
  #Class = 0x000100
+ Class = 0x20041C

***************
*** 15,17 ****
  # 0 = disable timer, i.e. stay discoverable forever
! #DiscoverableTimeout = 0

--- 17,19 ----
  # 0 = disable timer, i.e. stay discoverable forever
! DiscoverableTimeout = 0
EOT

sudo patch /etc/pulse/daemon.conf << EOT
***************
*** 54,55 ****
--- 54,56 ----
  ; resample-method = speex-float-1
+ resample-method = speex-fixed-2
  ; enable-remixing = yes
EOT

sudo patch /etc/pulse/system.pa << EOT
***************
*** 23,25 ****
  .ifexists module-udev-detect.so
! load-module module-udev-detect
  .else
--- 23,26 ----
  .ifexists module-udev-detect.so
! #load-module module-udev-detect
! load-module module-udev-detect tsched=0
  .else
***************
*** 57 ****
--- 58,63 ----
  load-module module-position-event-sounds
+
+ ### Automatically load driver modules for Bluetooth hardware
+ .ifexists module-bluetooth-discover.so
+     load-module module-bluetooth-discover
+ .endif
EOT


sudo service bluetooth start
sudo service pulseaudio start
sudo service bluetooth-agent start

echo "Done! You should reboot now"
