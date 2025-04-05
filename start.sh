#!/bin/bash

# Helpful to read output when debugging
set -x

source "/etc/libvirt/hooks/kvm.conf"

#may not be required, if snd_hda_intel fails to remove, make sure your audio service(in my case pipewire) is stopped by uncommenting this line
#then, go to revert.sh and uncomment the line near the bottom which starts pipewire
# systemctl stop YOUR_AUDIO_SERVICE


#replace sddm with your display manager, or consult other guides for how to do VFIO with those display managers
systemctl stop sddm
#Add additional services that use the amdgpu driver below this line


echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

sleep 10


modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

modprobe -r amdgpu
modprobe -r snd_hda_intel

virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

sleep 10
