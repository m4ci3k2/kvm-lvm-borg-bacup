# Synopsis

A simple script to backup KVM guests using borg backup 

# Installation
Copy this scripts to /root/backup-lvm.
```
# apt-get install borgbackup
# cp backup-lvm.cron /etc/cron.d
```

## Create user on server
useradd -m -b /backup borg-$HOST
UHOME=/backup/borg-$HOST
mkdir -m 0700 /$HOST/.ssh
echo command=\"borg serve --restrict-to-repository $UHOME\",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJSkem/EHrXiiMleomgNQ7deBLOuVMt6GZR4PqC+GDCu root@ns3163718 >> $UHOME/.ssh/authorized_keys
chmod 600 $UHOME/.ssh/authorized_keys

## Initialization on client
borg init -e keyfile-blak2 --make-parent-dirs  /backup/$HOST
borg key export --qr-html /backup/$HOST $HOST.html
echo "Print and store $HOST.html"

# Usage
Cron will send backup reports to you.
