#!/bin/bash

## [en] Create and configure a new virtual machine
## [de] Virtuelle Maschine in VirtualBox anlegen und einrichten


# [en] create and register VM
# [de] VM erstellen und registrieren
VBoxManage createvm --name "RT-1" --register
VBoxManage modifyvm RT-1 --memory 1024
VBoxManage modifyvm RT-1 --description "OPNsense lab"
VBoxManage modifyvm RT-1 --ostype "FreeBSD_64"
VBoxManage modifyvm RT-1 --ioapic on

# [en] set up network adapter
# [de] Netzwerkkarten einrichten
VBoxManage modifyvm RT-1 --nic1 bridged
VBoxManage modifyvm RT-1 --bridgeadapter1 eth1
VBoxManage modifyvm RT-1 --nictype1 virtio
VBoxManage modifyvm RT-1 --macaddress1 001516010001

VBoxManage modifyvm RT-1 --nic2 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter2 "vboxnet1"
VBoxManage modifyvm RT-1 --nictype2 virtio
VBoxManage modifyvm RT-1 --macaddress2 001516010101

VBoxManage modifyvm RT-1 --nic3 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter3 "vboxnet4"
VBoxManage modifyvm RT-1 --nictype3 virtio
VBoxManage modifyvm RT-1 --macaddress3 001516010401

VBoxManage modifyvm RT-1 --nic4 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter4 "vboxnet7"
VBoxManage modifyvm RT-1 --nictype4 virtio
VBoxManage modifyvm RT-1 --macaddress4 001516010701

VBoxManage modifyvm RT-1 --nic5 hostonly
VBoxManage modifyvm RT-1 --hostonlyadapter5 "vboxnet6"
VBoxManage modifyvm RT-1 --nictype5 virtio
VBoxManage modifyvm RT-1 --macaddress5 001516010601


# [en] CD drive (used during installation)
# [de] CD-ROM Laufwerk (für Installation)
VBoxManage storagectl RT-1 --name "IDE Controller" --add ide
VBoxManage storageattach RT-1 --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium /data/vmware/images/OPNsense-19.1.4-OpenSSL-dvd-amd64.iso

# [en] hard disk
# [de] Festplatte
VBoxManage storagectl RT-1 --name "SATA Controller" --add sata
VBoxManage createhd --filename "RT-1/RT-1.vdi" --size 4096 --format VDI --variant Fixed
VBoxManage storageattach RT-1 --storagectl "SATA Controller" --medium "RT-1/RT-1.vdi" --port 0 --type hdd

# RDP-Konsole
VBoxManage modifyvm RT-1 --vrde on
VBoxManage modifyvm RT-1 --vrdeport 8001
