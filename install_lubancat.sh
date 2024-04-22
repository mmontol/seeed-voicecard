#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 1>&2
   exit 1
fi

# Check for enough space on /boot volume
boot_line=$(df -h | grep /boot | head -n 1)
if [ "x${boot_line}" = "x" ]; then
  echo "Warning: /boot volume not found .."
else
  boot_space=$(echo $boot_line | awk '{print $4;}')
  free_space=$(echo "${boot_space%?}")
  unit="${boot_space: -1}"
  if [[ "$unit" = "K" ]]; then
    echo "Error: Not enough space left ($boot_space) on /boot"
    exit 1
  elif [[ "$unit" = "M" ]]; then
    if [ "$free_space" -lt "25" ]; then
      echo "Error: Not enough space left ($boot_space) on /boot"
      exit 1
    fi
  fi
fi

# overlay dir
# check for /boot/dtb/overlay
errorFound=0

OVERLAYS=/boot/dtb/overlay

if [ ! -d $OVERLAYS ] ; then
  echo "$OVERLAYS not found or not a directory" 1>&2
  errorFound=1
fi

ver="0.3"
uname_r=$(uname -r)

# we create a dir with this version to ensure that 'dkms remove' won't delete
# the sources during kernel updates
marker="0.0.0"

# update and install required packages
which apt &>/dev/null
if [[ $? -eq 0 ]]; then
  apt update -y
  # install kernel packages
  # apt-get -y install linux-headers-4.19.232 linux-image-4.19.232
  apt-get -y install dkms git i2c-tools libasound2-plugins libssl-dev
fi

# Arch Linux
# which pacman &>/dev/null
# if [[ $? -eq 0 ]]; then
#   pacman -Syu --needed git gcc automake make dkms linux-raspberrypi-headers i2c-tools
# fi

# locate currently installed kernels (may be different to running kernel if
# it's just been updated)
# base_ver=$(get_kernel_version)
# base_ver=${base_ver%%[-+]*}
#kernels="${base_ver}+ ${base_ver}-v7+ ${base_ver}-v7l+"
kernels=$(uname -r)

function install_module {
  local _i

  src=$1
  mod=$2

  if [[ -d /var/lib/dkms/$mod/$ver/$marker ]]; then
    rmdir /var/lib/dkms/$mod/$ver/$marker
  fi

  if [[ -e /usr/src/$mod-$ver || -e /var/lib/dkms/$mod/$ver ]]; then
    dkms remove --force -m $mod -v $ver --all
    rm -rf /usr/src/$mod-$ver
  fi

  mkdir -p /usr/src/$mod-$ver
  cp -a $src/* /usr/src/$mod-$ver/

  dkms add -m $mod -v $ver
  for _i in $kernels; do
    dkms build -k $_i -m $mod -v $ver && {
      dkms install --force -k $_i -m $mod -v $ver
    }
  done

  mkdir -p /var/lib/dkms/$mod/$ver/$marker
}

pushd /lib/modules/$kernels/build 
make scripts || true
popd -1

install_module "./" "seeed-voicecard"

# install dtbos,
# cp seeed-2mic-voicecard.dtbo $OVERLAYS
cp seeed-4mic-voicecard-lubancat.dtbo $OVERLAYS
# cp seeed-8mic-voicecard.dtbo $OVERLAYS

#set kernel modules
grep -q "^snd-soc-seeed-voicecard$" /etc/modules || \
  echo "snd-soc-seeed-voicecard" >> /etc/modules
grep -q "^snd-soc-ac108$" /etc/modules || \
  echo "snd-soc-ac108" >> /etc/modules
grep -q "^snd-soc-wm8960$" /etc/modules || \
  echo "snd-soc-wm8960" >> /etc/modules  

# add dtoverlays - Lubancat:
CONFIG=/boot/uEnv/uEnv.txt
sed -i "/#40pin/a\dtoverlay=/dtb/overlay/seeed-4mic-voicecard-lubancat.dtbo" $CONFIG
sync

# install config files
mkdir /etc/voicecard || true
cp *.conf /etc/voicecard
cp *.state /etc/voicecard

cp seeed-voicecard-lubancat /usr/bin/
cp seeed-voicecard-lubancat.service /lib/systemd/system/
# systemctl enable  seeed-voicecard.service 
# systemctl start   seeed-voicecard

echo "------------------------------------------------------"
echo "Please reboot your lubancat to apply all settings"
echo "Enjoy!"
echo "------------------------------------------------------"
