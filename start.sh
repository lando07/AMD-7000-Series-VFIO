#!/bin/bash

# Helpful to read output when debugging
set -x

source "/etc/libvirt/hooks/kvm.conf"

#may not be required, if snd_hda_intel fails to remove, make sure your audio service(in my case pipewire) is stopped by uncommenting this line
#then, go to revert.sh and uncomment the line near the bottom which starts pipewire
# systemctl stop YOUR_AUDIO_SERVICE


systemctl stop sddm coolercontrold

echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

#uncomment the next line if you're getting a black screen
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

sleep 10

modprobe -r amdgpu
modprobe -r snd_hda_intel

modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1


virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO


sleep 10

