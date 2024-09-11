#!/system/bin/sh
#
# ADDOND_VERSION=3
# 
# Custom kernel addon.d survival script for A/B partitions

if [[ -e /data/adb/ksu/bin/magiskboot ]]; then
  MAGISKBOOT=/data/adb/ksu/bin/magiskboot
elif [[ -e /data/adb/magisk/magiskboot ]]; then
  MAGISKBOOT=/data/adb/magisk/magiskboot
else
  MAGISKBOOT=false
fi
# Load helper functions of A/B environment
#. /postinstall/tmp/backuptool.functions

# Variables
CURRENT_SLOT="$(getprop ro.boot.slot_suffix)"
BOOTPARTITION=/dev/block/bootdevice/by-name/boot$CURRENT_SLOT
TMPDIR=/data/local/tmp/kernel/tmp
BACKUPDIR=/data/local/tmp/kernel/backup
LOGFILE=/data/local/tmp/kernel.log

if [[ "$CURRENT_SLOT" == "_a" ]]; then
    OTHER_SLOT="_b"
elif [[ "$CURRENT_SLOT" == "_b" ]]; then
    OTHER_SLOT="_a"
fi

NEWBOOT=/dev/block/bootdevice/by-name/boot$OTHER_SLOT

case "$1" in
  backup)
    rm -rf $LOGFILE
    mkdir -p $BACKUPDIR
    mkdir -p $TMPDIR
    echo "$NEWBOOT" >> $BACKUPDIR/dest
    echo "Target boot partition $NEWBOOT" >> $LOGFILE
    dd if="$BOOTPARTITION" of="$BACKUPDIR/boot.img" >> $LOGFILE
  ;;
  restore)
    if [[ $MAGISKBOOT == false ]]; then
      NEWBOOT="$(cat $BACKUPDIR/dest)"
      echo "Set new boot to readwrite" >> $LOGFILE
      blockdev --setrw "$NEWBOOT" >> $LOGFILE
      echo "Flashing to $NEWBOOT" >> $LOGFILE
      dd if="$BACKUPDIR/boot.img" of="$NEWBOOT" >> $LOGFILE
      echo "Completed" >> $LOGFILE
      rm -rf $BACKUPDIR
    else
      NEWBOOT="$(cat $BACKUPDIR/dest)"
      cd $TMPDIR
      $MAGISKBOOT unpack "$BACKUPDIR/boot.img" >> $LOGFILE
      cp kernel "$BACKUPDIR/kernel"
      rm -f *
      $MAGISKBOOT unpack "$NEWBOOT" >> $LOGFILE
      cp "$BACKUPDIR/kernel" kernel
      $MAGISKBOOT repack "$NEWBOOT" >> $LOGFILE
      cp new-boot.img "$BACKUPDIR/boot.img"
      echo "Set new boot to readwrite" >> $LOGFILE
      blockdev --setrw "$NEWBOOT" >> $LOGFILE
      echo "Flashing to $NEWBOOT" >> $LOGFILE
      dd if="$BACKUPDIR/boot.img" of="$NEWBOOT" >> $LOGFILE
      echo "Completed" >> $LOGFILE
      rm -rf $TMPDIR
      rm -rf $BACKUPDIR
    fi
  ;;
  pre-backup)
  ;;
  post-backup)
  ;;
  pre-restore)
  ;;
  post-restore)
  ;;
esac



