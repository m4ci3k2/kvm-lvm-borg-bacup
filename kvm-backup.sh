#!/bin/bash
set -e

export BORG_REPO=/backup/1
LVPATH=/dev/vg/
LVNAME=`lvs --noheadings -o lv_name | tr -d '  '`

backup_LV() {
  echo "Backing up LV $1"
  xmlfile=/etc/libvirt/qemu/"${1%-lv}".xml
  if [[ ! -e "$xmlfile" ]]; then
    echo "skipping as $xmlfile does not exist"
    return
  fi
  echo " => Creating snapshot $1-snapshot"
  lvcreate --size 5120M --snapshot --name "$1-snapshot" $LVPATH$1
  echo " => Creating archive with snapshot and $xmlfile"
  SNAPSHOT=$LVPATH$1-snapshot
  borg create -svp --list -C lz4 --read-special "::$1-`date +%Y-%m-%d`" "$xmlfile" "$SNAPSHOT"
  echo " => Deleting snapshot"
  lvremove -f $SNAPSHOT
  echo "Done LV $1"
}

prune_LV() {
  echo "Pruning LV $1"
  borg prune --info --list --prefix "$1-" --keep-daily=7 --keep-weekly=4 --keep-monthly=3
  echo "Done pruning LV $1"
}

for VM in $LVNAME;
do
  backup_LV "$VM"
  prune_LV "$VM"
done
