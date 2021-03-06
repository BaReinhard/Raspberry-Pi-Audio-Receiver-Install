#!/bin/bash

log="./runall.log"
echo "" > $log

read -p "Device name: " MYNAME
read -p "Device WiFi Password: " WIFIPASS

#--------------------------------------------------------------------
function tst {
    echo "===> Executing: $*"
    if ! $*; then
        echo "Exiting script due to error from: $*"
        exit 1
    fi
}
#--------------------------------------------------------------------
chmod +x ./*
echo "Starting @ `date`" | tee -a $log
echo "--------------------------------------------" | tee -a $log
tst ./bt_pa_prep.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
tst ./bt_pa_install.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
echo "${MYNAME}" | tst ./bt_pa_config.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
tst ./sound_card_install.sh | tee -a $log
tst ./airplay_install.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
echo "${MYNAME}" | tst ./airplay_config.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
tst ./kodi_install.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
tst ./kodi_config.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
tst ./lirc_install.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
tst ./lirc_config.sh | tee -a $log
echo "--------------------------------------------" | tee -a $log
echo "Ending at @ `date`" | tee -a $log
reboot
